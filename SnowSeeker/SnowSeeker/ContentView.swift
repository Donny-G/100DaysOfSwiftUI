//
//  ContentView.swift
//  SnowSeeker
//
//  Created by DeNNiO   G on 26.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

//!режим отображения в зависимости от устройства
extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            //всегда показывать одно вью
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}


enum Sorting {
    case def, alphabetical, country, numericSize, numericPrice
}

enum CountryFilter {
    case all, au, us, it, fr, ca
}

enum SizeFilter {
    case all, little, middle, large
}

enum PriceFilter {
    case  all, cheap, expensive
}



struct ContentView: View {
    
    
    @ObservedObject var favorites = Favorites()
    
    @State private var sorting: Sorting = .def
    @State private var countryFilter: CountryFilter = .all
  
    
    @State private var showSortAlertSheet = false
    @State private var showFilterSheet = false
    
    var resorts: [Resort]{
        let allResorts = Bundle.main.decode("resorts.json") as [Resort]
        var filteredResorts = allResorts
        
        switch countryFilter {
        case .all:
            filteredResorts = allResorts
        case .au:
            filteredResorts = allResorts.filter { $0.country == "Austria" }
        case .ca:
            filteredResorts = allResorts.filter { $0.country == "Canada" }
        case .fr:
            filteredResorts = allResorts.filter { $0.country == "France" }
        case .it:
            filteredResorts = allResorts.filter { $0.country == "Italy" }
        case .us:
            filteredResorts = allResorts.filter { $0.country == "United States" }
        }
    
        switch sorting {
        case .def:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name < $1.name }
        case .country:
            return filteredResorts.sorted { $0.country < $1.country }
        case .numericPrice: return filteredResorts.sorted { $0.price < $1.price }
        case .numericSize: return filteredResorts.sorted { $0.size < $1.size
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    //!настройка картинки для лучшего отображения
                    Image(resort.country)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 25)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.black, lineWidth: 1)
                        
                    )
                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }.layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(Color.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading: Button("Sorting") {
                self.showSortAlertSheet = true }, trailing: Button("Filter") { self.showFilterSheet = true})
            .actionSheet(isPresented: $showSortAlertSheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Sorting"), message: Text("Choose sorting style"), buttons: [
                        .default(Text("Default"), action: {
                            self.sorting = .def
                        }),
                        .default(Text("ABC by name"), action: {
                            self.sorting = .alphabetical
                        }),
                        .default(Text("123 by price"), action: {
                            self.sorting = .numericPrice
                        }),
                        .default(Text("123 by size"), action: {
                            self.sorting = .numericSize
                        }),
                        .default(Text("ABC by country"), action: {
                            self.sorting = .country
                        })
                    ])
            }
            
            WelcomeView()
            //!
        }.phoneOnlyStackNavigationView()
        .environmentObject(favorites)
        .actionSheet(isPresented: $showFilterSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Filter"), message: Text("Choose filter"), buttons: [
                .default(Text("Country:")),
                .default(Text("All countries"), action: {
                    self.countryFilter = .all
                }),
                .default(Text("Austria"), action: {
                    self.countryFilter = .au
                }),
                .default(Text("Canada"), action: {
                    self.countryFilter = .ca
                }),
                .default(Text("France"), action: {
                    self.countryFilter = .fr
                }),
                .default(Text("Italy"), action: {
                    self.countryFilter = .it
                }),
                .default(Text("United States"), action: {
                    self.countryFilter = .us
                }),
                .default(Text("Reset filters"), action: {
                    self.countryFilter = .all
                  
                    
                }),
                .cancel()
            ])
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
