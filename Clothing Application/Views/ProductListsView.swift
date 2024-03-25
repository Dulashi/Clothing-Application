//
//  ProductListsView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-21.
//

import SwiftUI

struct ProductListsView: View {
    @StateObject var viewModel = ProductViewModel()
    @State private var isShowingSortOptions = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button(action: {
                        // Handle back button action
                    }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .foregroundColor(.gray)

                    }
                    Spacer()
                    Text("DRESSES")
                        .font(.title)
                        .fontWeight(.medium)
                    Spacer()
                    Button(action: {
                        // Handle cart button action
                    }) {
                        Image(systemName: "cart")
                            .padding()
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
              
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingSortOptions.toggle()
                    }) {
                        Text("Sort | Filter")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    Spacer()
                }
                
              
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.products, id: \.name) { product in
                        ProductItemView(product: product)
                    }
                }
                .padding()
                .onAppear {
                    viewModel.fetchProducts { _, _ in }
                }
            }
            .sheet(isPresented: $isShowingSortOptions, content: {
                SortOptionsView()
            })
        }
    }
}
        
struct ProductItemView: View {
    let product: Product
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack {
            if let imageData = imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .cornerRadius(30)
                    .overlay(
                        Button(action: {
                            // Add your action here when the plus button is tapped
                        }) {
                            Image(systemName: "plus")
                                .padding(8)
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.8))
                                .clipShape(Circle())
                                .padding(8)
                        }
                            .offset(x: -40, y: 0),
                        alignment: .topTrailing
                    )
            } else {
                Color.gray
                    .frame(width: 200, height: 200)
                    .cornerRadius(20)
                    .onAppear {
                        loadImage()
                    }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.system(size: 14))
                    .lineLimit(2)
                    .padding(.horizontal, 5)
                    
                    Text("LKR \(String(format: "%.2f", product.price))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 5)
            
              Button(action: {
                   
               }) {
                   // Image(systemName: "heart")
                     //   .foregroundColor(.black)
                       // .offset(x: 60, y: -20);
                        
                        
                }
                .frame(width: 170)
                .padding(.vertical, 5)
                .background(Color.white)
                .cornerRadius(10)
                
            }
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
}
                struct SortOptionsView: View {
                    var body: some View {
                        VStack {
                            Text("Sort by:")
                                .font(.headline)
                                .padding(.bottom)
                            
                            Button(action: {
                                // Action when "Featured" is selected
                            }) {
                                HStack {
                                    Text("Featured")
                                        .foregroundColor(.black)
                                    Spacer()
                                    if isSelected("Featured") {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                // Action when "Newest" is selected
                            }) {
                                HStack {
                                    Text("Newest")
                                        .foregroundColor(.black)
                                    Spacer()
                                    if isSelected("Newest") {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                // Action when "Best Selling" is selected
                            }) {
                                HStack {
                                    Text("Best Selling")
                                        .foregroundColor(.black)
                                    Spacer()
                                    if isSelected("Best Selling") {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                // Action when "Price: Low to High" is selected
                            }) {
                                HStack {
                                    Text("Price: Low to High")
                                        .foregroundColor(.black)
                                    Spacer()
                                    if isSelected("Price: Low to High") {
                                        Image(systemName: "checkmark")
                                            
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                // Action when "Price: High to Low" is selected
                            }) {
                                HStack {
                                    Text("Price: High to Low")
                                        .foregroundColor(.black)
                                    Spacer()
                                    if isSelected("Price: High to Low") {
                                        Image(systemName: "checkmark")
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                            }
                            .padding(.bottom)
                            
                            Button(action: {
                                // Apply selected sort option
                            }) {
                                Text("Apply")
                                    .foregroundColor(.white)
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color.black.opacity(10))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding()
                        .shadow(radius: 5)
                    }
                    
                    private func isSelected(_ option: String) -> Bool {
                        // Implement logic to check if option is selected
                        return false
                    }
                }
            
        
    

