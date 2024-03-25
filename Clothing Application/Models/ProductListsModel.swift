//
//  ProductListsModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import Foundation

struct Product: Codable {
    let name: String
    let category: String
    let price: Double
    let sizes: [String]
    let colors: [String]
    let description: String
    let imageUrls: [String]
    let available: Bool
}
