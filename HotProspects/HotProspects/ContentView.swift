//
//  ContentView.swift
//  HotProspects
//
//  Created by DeNNiO   G on 17.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import UserNotifications


struct ContentView: View {
    //env
    var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
            .tabItem {
                Image(systemName: "person.3")
                Text("Everyone")
            }
            ProspectsView(filter: .contacted)
            .tabItem{
                Image(systemName: "checkmark.circle")
                Text("Contacted")
            }
            ProspectsView(filter: .uncontacted)
            .tabItem{
                Image(systemName: "questionmark.diamond")
                Text("Uncontacted")
            }
            MeView()
                .tabItem{
                    Image(systemName: "person.crop.square")
                    Text("Me")
            }
            //env
        }.environmentObject(prospects)
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
