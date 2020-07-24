//
//  Movie+CoreDataProperties.swift
//  Project12(CoreData+)
//
//  Created by DeNNiO   G on 03.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var title: String?
    @NSManaged public var director: String?
    @NSManaged public var year: Int16
    
    //безопасно раскрываем опционал в самом подклассе NSManagedObject
    public var wrappedTitle: String {
        title ?? "Unknown Title"
    }

}
