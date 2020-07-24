//
//  ContentView.swift
//  Project12(CoreData+)
//
//  Created by DeNNiO   G on 03.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

//вместо identifiable можно использовать hashable
struct Student: Hashable {
    let name: String
}


struct ContentView: View {
    
 //   let students = [Student(name: "af"), Student(name: "Ds")]
    
    @Environment(\.managedObjectContext) var moc
    
  //  @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
   @State private var lastNameFilter = "A"
    
    
    var body: some View {
   
         VStack {
            FilteredList(filter: lastNameFilter, keyValue: .firstName, predicateType: .showAll)
                   

                   Button("Add Examples") {
                       let taylor = Singer(context: self.moc)
                       taylor.firstName = "Taylor"
                       taylor.lastName = "Swift"

                       let ed = Singer(context: self.moc)
                       ed.firstName = "Ed"
                       ed.lastName = "Sheeran"

                       let adele = Singer(context: self.moc)
                       adele.firstName = "Adele"
                       adele.lastName = "Adkins"

                       try? self.moc.save()
                   }

                   Button("Show A") {
                       self.lastNameFilter = "A"
                   }
                   

                   Button("Show S") {
                       self.lastNameFilter = "S"
                   }
               }
}
            
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
