//
//  WishlistView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import SwiftUI

struct WishlistView: View {
    @ObservedObject var wishlistManager = WishlistManager.shared

    var body: some View {
            Text("Wishlist")
               .font(.title)
                   .padding()
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(wishlistManager.wishlistProducts, id: \.name) { product in
                        WishlistItemView(product: product)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
       
}



struct WishlistItemView: View {
    let product: Product
    
    var body: some View {
        VStack {
            // Product image
            if let firstImageUrl = product.imageUrls.first,
               let url = URL(string: firstImageUrl),
               let imageData = try? Data(contentsOf: url),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
            } else {
                Color.gray
                    .frame(width: 150, height: 150)
                    .cornerRadius(10)
            }
            
            // Product name
            Text(product.name)
                .font(.headline)
                .padding(.top, 5)
            
            // Product price
            Text("LKR \(String(format: "%.2f", product.price))")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
