//
//  UserCoreData+CoreDataProperties.swift
//  DataMilestone
//
//  Created by DeNNiO   G on 08.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var about: String?
    var wrappedAbout: String {
        about ?? "Unknown"
    }
    
    @NSManaged public var address: String?
    var wrappedAddress: String {
        address ?? "Unknown"
    }
    
    @NSManaged public var age: Int16
    var wrappedAge: Int16 {
        age ?? 0
    }
    
    @NSManaged public var company: String?
    var wrappedCompany: String {
        company ?? "Unknown"
    }
    
    @NSManaged public var email: String?
    var wrappedEmail: String {
        email ?? "Unknown"
    }
    
    @NSManaged public var id: String?
    var wrappedId: String {
        id ?? "Unknown"
    }
    
    @NSManaged public var name: String?
    var wrappedName: String {
        name ?? "Unknown"
    }
    
    @NSManaged public var friends: NSSet?
    
    public var friendsArray: [FriendCoreData] {
        let set = friends as? Set<FriendCoreData> ?? []
        return set.sorted { $0.wrappedName < $1.wrappedName
        }
    }
    
}

// MARK: Generated accessors for friends
extension UserCoreData {

    @objc(addFriendsObject:)
    @NSManaged public func addToFriends(_ value: FriendCoreData)

    @objc(removeFriendsObject:)
    @NSManaged public func removeFromFriends(_ value: FriendCoreData)

    @objc(addFriends:)
    @NSManaged public func addToFriends(_ values: NSSet)

    @objc(removeFriends:)
    @NSManaged public func removeFromFriends(_ values: NSSet)

}
