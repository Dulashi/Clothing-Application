//
//  CheckoutView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-27.
//

import SwiftUI

struct CheckoutView: View {
    @Binding var selectedProducts: [Product]
    @Binding var quantities: [Int] // Binding for quantities
    @State private var imageDatas: [Data?] // State to store image data
    @State private var email = ""
    @State private var fullName = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var postalCode = ""
    @State private var selectedCountry = "Select Country"
    @State private var paymentNumber = ""
    @State private var showAlert = false
    
    let countries = ["Select Country", "USA", "Canada", "UK", "Australia", "Sri Lanka", "France", "Japan", "India", "China"]
    
    init(selectedProducts: Binding<[Product]>, quantities: Binding<[Int]>) {
        self._selectedProducts = selectedProducts
        self._quantities = quantities
        self._imageDatas = State(initialValue: Array(repeating: nil, count: selectedProducts.wrappedValue.count))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Checkout")
                        .font(.title)
                        .padding()
                    
                    // Shipping section
                    Section("Shipping") {
                        TextField("Email", text: $email)
                            .padding()
                        TextField("Full Name", text: $fullName)
                            .padding()
                        TextField("Street Address", text: $streetAddress)
                            .padding()
                        TextField("City", text: $city)
                            .padding()
                        TextField("Postal Code", text: $postalCode)
                            .padding()
                        Picker(selection: $selectedCountry, label: Text("Country")) {
                            ForEach(countries, id: \.self) { country in
                                Text(country)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                    }
                    
                    // Payment section
                    Section("Payment") {
                        TextField("Payment Number", text: $paymentNumber)
                            .padding()
                    }
                    
                    // Summary section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)
                        HStack {
                            Text("Subtotal:")
                            Spacer()
                            Text("LKR \(String(format: "%.2f", totalPrice))")
                        }
                        HStack {
                            Text("Shipping Tax:")
                            Spacer()
                            Text("LKR 0.00") // Shipping tax is zero for now
                        }
                        HStack {
                            Text("Number of Items:")
                            Spacer()
                            Text("\(totalNumberOfItems)")
                        }
                        HStack {
                            Text("Total:")
                            Spacer()
                            Text("LKR \(String(format: "%.2f", totalPrice))")
                        }
                    }
                    .padding()
                    
                    // Place the Order button
                    Button(action: placeOrder) {
                        Text("Place the Order")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    // Product images grid
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.flexible())], spacing: 10) {
                            ForEach(selectedProducts.indices, id: \.self) { index in
                                if let imageData = imageDatas[index], let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                        .padding(.horizontal, 4)
                                } else {
                                    Color.gray
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(5)
                                        .padding(.horizontal, 4)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .navigationBarItems(trailing:
                    Button("Close") {
                        // Action to close the CheckoutView
                    }
                )
                .onAppear {
                    // Load images when the view appears
                    for index in selectedProducts.indices {
                        loadImage(for: index)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Order Confirmation"), message: Text("Your Order has been confirmed"), primaryButton: .default(Text("OK"), action: {
                        // Action when OK button is tapped
                        // Navigate to HomeView
                        // You need to define the navigation logic to go to HomeView
                    }), secondaryButton: .cancel())
                }
            }
        }
    }
    
    var totalPrice: Double {
        var total: Double = 0.0
        for (index, product) in selectedProducts.enumerated() {
            total += product.price * Double(quantities[index])
        }
        return total
    }
    
    var totalNumberOfItems: Int {
        var totalItems = 0
        for quantity in quantities {
            totalItems += quantity
        }
        return totalItems
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
    
    private func placeOrder() {
        showAlert = true // Show the confirmation alert
    }
}
