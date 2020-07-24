//
//  Favorites.swift
//  SnowSeeker
//
//  Created by DeNNiO   G on 29.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

class Favorites: ObservableObject {
    private var resorts: Set<String>
    
    private let saveKey = "Favorites"
    
    init() {
        if let savedData = UserDefaults.standard.data(forKey: saveKey) {
            if let encodedData = try?  JSONDecoder().decode(Set<String>.self, from: savedData) {
                resorts = encodedData
                return
            }
        }
        self.resorts = []
    }
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        if let encodedData = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(encodedData, forKey: saveKey)
        } else {
            fatalError("Unable to save data")
        }
    }
}
