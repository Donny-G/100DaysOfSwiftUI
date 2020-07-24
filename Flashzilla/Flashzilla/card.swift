//
//  card.swift
//  Flashzilla
//
//  Created by DeNNiO   G on 20.06.2020.
//  Copyright © 2020 Donny G. All rights reserved.
//

import Foundation

struct  Card: Codable  {
    let prompt: String
    let answer: String
    
    static var example: Card {
        return Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    }
}
