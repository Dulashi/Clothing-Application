//
//  WishlistView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import SwiftUI

struct WishlistView: View {
    @ObservedObject var wishlistManager = WishlistManager.shared
    @Binding var selectedProducts: [Product]
    @State private var cartItemsCount = 0
    
    let email: String
    let password: String
    
    // Boolean to track if the view is active
    @State private var isActive: Bool = false

    var body: some View {
        VStack {
            Text("Wishlist")
                .fontWeight(.regular)
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(wishlistManager.wishlistProducts, id: \.name) { product in
                        WishlistItemView(product: product, selectedProducts: $selectedProducts, cartItemsCount: $cartItemsCount)
                    }
                }
                .padding()
            }
            BottomNavigationPanel(selectedProducts: $selectedProducts, email: email, password: password)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}



struct WishlistItemView: View {
    let product: Product
    @State private var imageData: Data? = nil
    @Binding var selectedProducts: [Product]
    @Binding var cartItemsCount: Int
    @State private var isWishlisted = true // Assume all items in wishlist are already wishlisted
    @State private var isShowingPopup = false // State variable to control pop-up presentation

    var body: some View {
        VStack(spacing: 10) {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                ZStack(alignment: .bottomLeading) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .cornerRadius(30)
                        .onTapGesture {
                            // Present detail view when tapped
                        }
                        .padding()

                    HStack {
                        Button(action: {
                            // Toggle the pop-up
                            isShowingPopup.toggle()
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.black)
                                .clipShape(Circle())
                        }
                        .offset(x: 170, y: -220)
                    }
                }
            } else {
                Color.gray
                    .frame(width: 250, height: 250)
                    .cornerRadius(30)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 14))
                    .lineLimit(2)

                Text("LKR \(String(format: "%.2f", product.price))")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 5) // Adjusted horizontal padding

        }
        .onAppear {
            loadImage()
        }
        .padding()
        // Show the pop-up sheet when isShowingPopup is true
        .sheet(isPresented: $isShowingPopup) {
            ProductSelectionPopup(product: product, cartItemsCount: $cartItemsCount, selectedProducts: $selectedProducts)
        }
    }

    private func loadImage() {
        guard let firstImageUrl = product.imageUrls.first,
              let url = URL(string: firstImageUrl) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }

            DispatchQueue.main.async {
                self.imageData = data
            }
        }.resume()
    }

    private func removeFromWishlist() {
        WishlistManager.shared.removeFromWishlist(product.name)
    }
}


#Preview{
    WishlistView(selectedProducts: .constant([]), email: "", password: "")
}
