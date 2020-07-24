//
//  ProspectsView.swift
//  HotProspects
//
//  Created by DeNNiO   G on 17.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI
import CodeScanner
import  UserNotifications


enum FilterType {
    case none, contacted, uncontacted
}

enum SortType {
    case name, date
}

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var alertSheetShown = false
    @State private var sortType: SortType = .name
    
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        
        }
    }
    //фильтр
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted
            }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted
            }
        }
    }
    
    var sortedProspects: [Prospect] {
        switch sortType {
        case .name:
            return filteredProspects.sorted { $0.name < $1.name }
        case .date:
            return filteredProspects .sorted { $0.dateOfAdd < $1.dateOfAdd }
        }
    }
    //Result<suces,error>
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            person.dateOfAdd = Date()
            self.prospects.add(person)
        case .failure(let error):
            print("Scanning failed\(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect){
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        center.getNotificationSettings {
            settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { succes, error in
                    if succes {
                        addRequest()
                    } else {
                        print("oops")
                    }
                }
            }
        }
        
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(sortedProspects) { prospect in
                    HStack {
                    Image(systemName: prospect.isContacted ? "eye" : "eye.slash")
                    VStack(alignment: .leading) {
                        Text(prospect.name)
                            .font(.headline)
                        Text(prospect.emailAddress)
                            .foregroundColor(.secondary)
                    
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            self.prospects.toggle(prospect)
                        }
                        if !prospect.isContacted {
                            Button("Remind me") {
                                self.addNotification(for: prospect)
                            }
                        }
                    }
                    
                }
            }
        }
        .navigationBarTitle(title)
            .navigationBarItems(leading: Button(action: {
                self.alertSheetShown = true
            }) {
                Image(systemName: "arrow.up.arrow.down")
                }, trailing: Button(action: {
                    self.isShowingScanner = true
                }){
                    Image(systemName: "qrcode.viewfinder")
                    Text("Scan")
                })
                .sheet(isPresented: $isShowingScanner) { CodeScannerView(codeTypes: [.qr], simulatedData: "PaulHudson\npaul@mail.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $alertSheetShown) {
                ActionSheet(title: Text("Sort by"), buttons: [
                    .default(Text("Name"), action: {
                    self.sortType = .name
                }),
                    .default(Text("Date"), action: {
                        self.sortType = .date
                    }),
                    .cancel()
                
                
                ])
            }
    }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
