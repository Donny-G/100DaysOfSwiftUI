//
//  FilteredList.swift
//  Project12(CoreData+)
//
//  Created by DeNNiO   G on 03.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import SwiftUI

enum BeginsWith {
    case lastName
    case firstName
}

enum PredicateType {
    case showAll
    case beginsWith
}

struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    init(filter: String, keyValue: BeginsWith, predicateType: PredicateType) {
        var key: String{
            switch keyValue {
            case .firstName:
                return "firstName"
            case .lastName:
                return "lastName"
            }
        }
        
        var pred: String {
            switch predicateType {
            case .beginsWith:
                return "%K BEGINSWITH %@"
            case .showAll:
                return "%K > %@"
            }
        }
        
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Singer.lastName, ascending: true)], predicate: NSPredicate(format: pred, key, filter))
    }
    
    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
}

