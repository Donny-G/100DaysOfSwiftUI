//
//  Result.swift
//  BucketList
//
//  Created by DeNNiO   G on 11.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

struct  Result: Codable {
    let query: Query
}

struct  Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
    
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
}
