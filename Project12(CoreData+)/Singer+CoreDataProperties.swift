//
//  Singer+CoreDataProperties.swift
//  Project12(CoreData+)
//
//  Created by DeNNiO   G on 03.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Singer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Singer> {
        return NSFetchRequest<Singer>(entityName: "Singer")
    }

    @NSManaged public var firstName: String?
    var wrappedFirstName: String {
        firstName ?? "Unknown"
    }
    
    @NSManaged public var lastName: String?
    var wrappedLastName: String {
        lastName ?? "Unknown"
    }

}
