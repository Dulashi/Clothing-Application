//
//  ProductViewModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []

    func fetchProducts(completion: @escaping ([Product]?, Error?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/products") else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        func fetchWishlistProducts() {
            let wishlistProducts = WishlistManager.shared.fetchWishlistProducts()
                    self.products = wishlistProducts

            }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            do {
                let decodedData = try JSONDecoder().decode([Product].self, from: data)
                let dressesProducts = decodedData.filter { $0.category == "Dresses" }
                DispatchQueue.main.async {
                    self.products = dressesProducts
                    completion(dressesProducts, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }.resume()
    }
}
