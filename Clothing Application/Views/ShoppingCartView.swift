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
    @State private var quantities: [Int] = []
    
    var totalPrice: Double {
        var total: Double = 0.0
        for index in 0..<selectedProducts.count {
            let product = selectedProducts[index]
            let quantity = index < quantities.count ? quantities[index] : 1
            total += product.price * Double(quantity)
        }
        return total
    }
    
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
                    List {
                        ForEach(selectedProducts.indices, id: \.self) { index in
                            let product = selectedProducts[index]
                            let imageData = index < imageDatas.count ? imageDatas[index] : nil
                            let quantity = index < quantities.count ? quantities[index] : 1
                            
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
                                    
                                    // Quantity selection
                                    Picker("Quantity", selection: Binding(
                                        get: { quantity },
                                        set: { quantities[index] = $0 }
                                    )) {
                                        ForEach(1...100, id: \.self) { quantity in
                                            Text("\(quantity)")
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                }
                                .padding(.vertical, 8)
                                
                                Spacer()
                                
                                // Delete button
                                DeleteButton {
                                    deleteProduct(at: index)
                                }
                            }
                            .padding(.horizontal)
                            .onAppear {
                                loadImage(for: index)
                                ensureQuantityCount(for: index)
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Total price display
                Text("Total: LKR \(String(format: "%.2f", totalPrice))")
                    .font(.headline)
                    .padding(.bottom)
                
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
    
    private func ensureQuantityCount(for index: Int) {
        while quantities.count <= index {
            quantities.append(1) // Default quantity is 1
        }
    }
    
    private func deleteProduct(at index: Int) {
        selectedProducts.remove(at: index)
        
        // Remove corresponding image data and quantity
        if index < imageDatas.count {
            imageDatas.remove(at: index)
        }
        if index < quantities.count {
            quantities.remove(at: index)
        }
    }
}

struct DeleteButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
