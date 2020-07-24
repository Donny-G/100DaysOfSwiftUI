//
//  UserModel.swift
//  DataMilestone
//
//  Created by DeNNiO   G on 04.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI



 class Users: ObservableObject {
   @Published var users = [User]()
  
    @Environment(\.managedObjectContext) var moc
    
    init() {
       loadData()
    }
    
    func loadData() {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("invalid url")
            return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                if  let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
                    
                    DispatchQueue.main.async {
                        self.users = decodedUsers
                    }
                    return
                }
            }
             print("Fetch Failed \(error?.localizedDescription  ?? "Unknown Error")")
        }.resume()
    }
}


struct User: Codable, Identifiable {
    var id: String
    var name: String
    var age: Int16
    var company: String
    var email: String
    var address: String
    var about: String
    var friends: [Friend]
}

struct Friend: Codable, Identifiable {
    var id: String
    var name: String
}
