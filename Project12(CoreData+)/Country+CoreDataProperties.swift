//
//  Country+CoreDataProperties.swift
//  Project12(CoreData+)
//
//  Created by DeNNiO   G on 03.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Country {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Country> {
        return NSFetchRequest<Country>(entityName: "Country")
    }

    @NSManaged public var fullName: String?
    public var wrappedFullName: String {
        fullName ?? "Unknown"
    }
    
    @NSManaged public var shortName: String?
    public var wrappedShortName: String {
        shortName ?? "Unknown"
    }
    
    @NSManaged public var candy: NSSet?
    
    public var candyArray: [Candy] {
        let set = candy as? Set<Candy> ?? []
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for candy
extension Country {

    @objc(addCandyObject:)
    @NSManaged public func addToCandy(_ value: Candy)

    @objc(removeCandyObject:)
    @NSManaged public func removeFromCandy(_ value: Candy)

    @objc(addCandy:)
    @NSManaged public func addToCandy(_ values: NSSet)

    @objc(removeCandy:)
    @NSManaged public func removeFromCandy(_ values: NSSet)

}
