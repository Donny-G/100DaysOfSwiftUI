//
//  FriendCoreData+CoreDataProperties.swift
//  DataMilestone
//
//  Created by DeNNiO   G on 07.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendCoreData> {
        return NSFetchRequest<FriendCoreData>(entityName: "FriendCoreData")
    }

    @NSManaged public var id: String?
    var wrappedId: String {
        id ?? "Unknown"
    }
    
    @NSManaged public var name: String?
    var wrappedName: String {
        name ?? "Unknown"
    }
    
    @NSManaged public var friend: UserCoreData?

}
