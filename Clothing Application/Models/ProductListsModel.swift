//
//  ProductListsModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import Foundation

struct Product: Codable {
    let name: String
    let description: String
    let price: Double
    let sizes: [String]
    let colors: [String]
    let imageUrls: [String] // Changed 'images' to 'imageUrls'
    let available: Bool
}
