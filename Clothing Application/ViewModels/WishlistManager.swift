//
//  WishlistManager.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-30.
//

import Foundation
import Combine

class WishlistManager: ObservableObject {
    static let shared = WishlistManager()
    private let userDefaults = UserDefaults.standard
    private let wishlistKey = "wishlist"
    
    @Published var wishlistProducts: [Product] = [] 
    init() {
        self.wishlistProducts = getWishlistProducts()
        resetWishlist()
    }

    func addToWishlist(name: String, price: Double, imageUrls: [String]) {
        var wishlistProducts = self.wishlistProducts
        
       
        let product = Product(name: name, category: "", price: price, sizes: [], colors: [], description: "", imageUrls: imageUrls, available: false)
        
        wishlistProducts.append(product)
        saveWishlistProducts(wishlistProducts)
    }
    
    func removeFromWishlist(_ productName: String) {
        var wishlistProducts = self.wishlistProducts
        wishlistProducts.removeAll { $0.name == productName }
        saveWishlistProducts(wishlistProducts)
    }
    
    func fetchWishlistProducts() -> [Product] {
        return getWishlistProducts()
    }
    
    private func getWishlistProducts() -> [Product] {
        guard let wishlistData = userDefaults.data(forKey: wishlistKey) else {
            return []
        }
        let decoder = JSONDecoder()
        if let wishlistProducts = try? decoder.decode([Product].self, from: wishlistData) {
            return wishlistProducts
        } else {
            return []
        }
    }
    
    private func saveWishlistProducts(_ products: [Product]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(products) {
            userDefaults.set(encodedData, forKey: wishlistKey)
            self.wishlistProducts = products
        }
    }
    func resetWishlist() {
        wishlistProducts = []
        userDefaults.removeObject(forKey: wishlistKey)
    }
}
