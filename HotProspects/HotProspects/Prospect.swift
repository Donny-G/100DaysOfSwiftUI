//
//  Prospect.swift
//  HotProspects
//
//  Created by DeNNiO   G on 18.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI


class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    @Published private(set) var people: [Prospect]
    
    init() {
                self.people = loadDAta()
    }
    
    func toggle(_ prospect: Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        saveData(what: people)
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        saveData(what: people)
    }
    
   
}

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var dateOfAdd = Date()
  fileprivate(set)  var isContacted = false
}



//with userDefaults
/*
class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    @Published private(set) var people: [Prospect]
    
    init() {
        
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
        
        
        self.people = []
    }
    
    func toggle(_ prospect: Prospect){
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
   private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
}
*/
