//
//  House.swift
//  DTT-Test
//
//  Created by Magdalena  Pękacka on 30.07.21.
//

import Foundation

struct House: Codable {
    
    let id: Int
    let image: String
    let price: Int
    let bedrooms: Int
    let bathrooms: Int
    let size: Int
    let description: String
    let zip: String
    let city: String
    let latitude: Int
    let longitude: Int
    let createdDate: String
}

