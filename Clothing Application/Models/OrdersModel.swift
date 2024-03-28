//
//  OrdersModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import Foundation

struct Order: Codable {
    let orderNumber: Int
    let fullName: String
    let email: String
    let country: String
    let streetAddress: String
    let city: String
    let postalCode: String
    let items: [String] 
    let totalNumberOfItems: Int
    let totalAmount: Double
}
