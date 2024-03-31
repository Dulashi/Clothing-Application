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
    @Binding var selectedProducts: [Product]
    @Binding var cartItemsCount: Int
    
    init(product: Product, selectedProducts: Binding<[Product]>, cartItemsCount: Binding<Int>) {
        self.product = product
        self._selectedProducts = selectedProducts
        self._cartItemsCount = cartItemsCount
        _selectedSize = State(initialValue: product.sizes.first)
        _selectedColor = State(initialValue: product.colors.first)
    }

    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
            
                VStack(alignment: .leading, spacing: 20) {
                    if let imageUrl = product.imageUrls.first,
                                   let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } else if phase.error != nil {
                                            Text("Failed to load image")
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 600, height: 500)
                                    .cornerRadius(20)
                                    .padding(.horizontal, -105)
                                }

                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                   
                    Text("LKR \(String(format: "%.2f", product.price))")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Size")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        
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
                    
                   
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Color")
                            .font(.headline)
                            .padding(.horizontal)
                        
                       
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
                                            
                                            Text(color)
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
                    
                    
                    Button(action: {
                        if let selectedSize = selectedSize, let selectedColor = selectedColor {
                            let selectedProduct = Product(
                                name: product.name,
                                category: "",
                                price: product.price,
                                sizes: [selectedSize],
                                colors: [selectedColor],
                                description: "",
                                imageUrls: product.imageUrls,
                                available: true
                            )
                            cartItemsCount += 1
                            selectedProducts.append(selectedProduct)
                        }
                    }) {
                        Text("Add to Cart")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                   
                    Text("Product Description:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(product.description)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}


//#Preview{
//    
//    
//}
