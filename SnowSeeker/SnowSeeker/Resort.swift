//
//  Resort.swift
//  SnowSeeker
//
//  Created by DeNNiO   G on 27.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    //для прототипирования в превью
    static let allResorts: [Resort] = Bundle.main.decode("resort.json")
    static let example = allResorts[0]
}
