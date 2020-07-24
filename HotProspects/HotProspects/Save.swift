//
//  Save.swift
//  HotProspects
//
//  Created by DeNNiO   G on 18.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    return paths[0]
}

func loadDAta() -> [Prospect] {
          let filename = getDocumentsDirectory().appendingPathComponent("SavedProspects")
    var savedProspects = [Prospect]()
          do {
              let data = try Data(contentsOf: filename)
             savedProspects = try JSONDecoder().decode([Prospect].self, from: data)
           
          } catch {
              print("Unable to load saved data")
          }
    return savedProspects
   }
      
func saveData(what: [Prospect]) {
          do {
              let filename = getDocumentsDirectory().appendingPathComponent("SavedProspects")
              let data = try JSONEncoder().encode(what)
              try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
          } catch {
              print("Unable to save data")
          }
   }
