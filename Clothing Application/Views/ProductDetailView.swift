//
//  ProductDetailView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-25.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var selectedSize: String?
    @State private var selectedColor: String?
    
    init(product: Product) {
        self.product = product
        _selectedSize = State(initialValue: product.sizes.first)
        _selectedColor = State(initialValue: product.colors.first)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Image
                    if let imageUrl = product.imageUrls.first,
                       let url = URL(string: imageUrl) {
                        AsyncImage(url: url)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    
                    // Name
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Price
                    Text("LKR \(String(format: "%.2f", product.price))")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // Select Size
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Size")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Buttons for sizes
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(product.sizes, id: \.self) { size in
                                    Button(action: {
                                        selectedSize = size
                                    }) {
                                        Text(size)
                                            .padding(.horizontal, 15)
                                            .padding(.vertical, 8)
                                            .background(selectedSize == size ? Color.black : Color.gray.opacity(0.5))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Select Color
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Color")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Buttons for colors
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(product.colors, id: \.self) { color in
                                    Button(action: {
                                        selectedColor = color
                                    }) {
                                        ZStack {
                                            Circle()
                                                .foregroundColor(Color(color))
                                                .frame(width: 30, height: 30)
                                            
                                            Text(color) // Display color names inside oval shapes
                                                .foregroundColor(.black)
                                                .font(.caption)
                                        }
                                    }
                                    .padding(5)
                                    .overlay(
                                        Circle()
                                            .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Add to Cart Button
                    Button(action: {
                        // Add to cart action
                    }) {
                        Text("Add to Cart")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    // Product Description
                    Text("Product Description:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(product.description)
                        .padding(.horizontal)
                }
                .padding(.vertical) // Add vertical padding to the VStack
                .frame(maxWidth: .infinity) // Ensure VStack doesn't exceed screen width
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Back button action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}
