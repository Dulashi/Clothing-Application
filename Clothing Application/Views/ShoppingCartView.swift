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
    @State private var isCheckoutSheetPresented = false
    @Binding var cartItemsCount: Int
    
    let email: String
    let password: String
    

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
                HStack {
                    Button(action: {
                        
                    }) {
                        NavigationLink(destination: CollectionsView(cartItemsCount: $cartItemsCount, email: email, password: password)) {
                            Image(systemName: "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 14, height: 14)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                    Spacer()
                    Text("My Cart")
                        .font(.title)
                        .padding()
                    Spacer()
                    Spacer()
                }

                Image("shoppingcartbanner")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 600, height: 150)
                    .padding(.leading, 8)

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
                                        .frame(width: 80, height: 80) // Adjust image size as needed
                                        .cornerRadius(5)
                                } else {
                                    Color.gray
                                        .frame(width: 80, height: 80) // Adjust placeholder size
                                        .cornerRadius(5)
                                }

                                // Product details
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                        .font(.system(size: 14))

                                    Text("LKR \(String(format: "%.2f", product.price))")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))

                                    Text("Size: \(product.sizes.first ?? "N/A")")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))

                                    Text("Color: \(product.colors.first ?? "N/A")")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 14))

                                    HStack {
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
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))

                                        Spacer()

                                        // Delete button
                                        DeleteButton {
                                            deleteProduct(at: index)
                                        }
                                    }
                                }
                                .padding(.trailing, 8) // Adjust trailing padding

                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                            .onAppear {
                                loadImage(for: index)
                                ensureQuantityCount(for: index)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }

                Spacer()

                // Total price display
                HStack {
                    Spacer()
                    Text("Total: LKR \(String(format: "%.2f", totalPrice))")
                        .font(.headline)
                    Spacer()
                }
                .padding(.vertical)

                Button(action: {
                    // Show checkout sheet
                    isCheckoutSheetPresented = true
                }) {
                    Text("Checkout")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $isCheckoutSheetPresented) {
                    CheckoutView(selectedProducts: $selectedProducts, quantities: $quantities)
                }

            }
        }
        .navigationBarBackButtonHidden(true)
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

#Preview{
    ShoppingCartView(selectedProducts: .constant([]), cartItemsCount: .constant(0), email: "", password: "")
}
