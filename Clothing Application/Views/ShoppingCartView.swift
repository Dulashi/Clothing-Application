//
//  ShoppingCartView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-25.
//

import SwiftUI

struct ShoppingCartView: View {
    @Binding var selectedProducts: [Product]
    @State private var imageDatas: [Data?] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Shopping Cart")
                    .font(.title)
                    .padding()
                
                if selectedProducts.isEmpty {
                    Text("No items in the shopping cart")
                        .foregroundColor(.gray)
                } else {
                    // Display selected products
                    List(selectedProducts.indices, id: \.self) { index in
                        let product = selectedProducts[index]
                        let imageData = index < imageDatas.count ? imageDatas[index] : nil
                        
                        HStack(spacing: 10) {
                            // Product image
                            if let imageData = imageData,
                               let uiImage = UIImage(data: imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100) // Adjust image size as needed
                                    .cornerRadius(5)
                            } else {
                                Color.gray
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                            }
                            
                            // Product details
                            VStack(alignment: .leading) {
                                Text(product.name)
                                    .font(.headline)
                                
                                Text("Price: LKR \(String(format: "%.2f", product.price))")
                                    .foregroundColor(.gray)
                                
                                Text("Size: \(product.sizes.first ?? "N/A")")
                                    .foregroundColor(.gray)
                                
                                Text("Color: \(product.colors.first ?? "N/A")")
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .onAppear {
                            loadImage(for: index)
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    // Action when checkout button is tapped
                }) {
                    Text("Checkout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
        }
    }
    
    private func loadImage(for index: Int) {
        guard let imageUrl = selectedProducts[index].imageUrls.first,
              let url = URL(string: imageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                // Make sure the imageDatas array has enough elements
                while index >= imageDatas.count {
                    imageDatas.append(nil)
                }
                imageDatas[index] = data
            }
        }.resume()
    }
}
