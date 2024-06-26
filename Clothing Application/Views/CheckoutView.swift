//
//  CheckoutView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-27.
//

import SwiftUI

struct CheckoutView: View {
    @Binding var selectedProducts: [Product]
    @Binding var quantities: [Int]
    @State private var imageDatas: [Data?]
    @State private var email = ""
    @State private var fullName = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var postalCode = ""
    @State private var paymentNumber = ""
    @State private var cvc = ""
    @State private var expiryDate = ""
    @State private var showAlert = false
    @State private var nextOrderNumber = 1
    @State private var password = ""
    @State private var navigateToLogin = false
    @State private var createdUser: User?
    @State private var orderDetails: Order?

    init(selectedProducts: Binding<[Product]>, quantities: Binding<[Int]>) {
        self._selectedProducts = selectedProducts
        self._quantities = quantities
        self._imageDatas = State(initialValue: Array(repeating: nil, count: selectedProducts.wrappedValue.count))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Checkout")
                        .font(.title)
                    HStack {
                        Label("Delivery Information", systemImage: "shippingbox.fill")
                            .foregroundColor(.brown)
                        Spacer()
                    }
                    .padding(.top)
                    Section {
                        VStack(alignment: .leading) {
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                               
                            
                            TextField("Full Name", text: $fullName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                                
                                                       
                            TextField("Street Address", text: $streetAddress)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                            
                            TextField("City", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                            
                            TextField("Postal Code", text: $postalCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(5)
                            
                                               }
                                           }
                                           HStack {
                                               Label("Payment Information", systemImage: "creditcard.fill")
                                                   .foregroundColor(.brown)
                                               Spacer()
                                           }
                                           Section {
                                               VStack(alignment: .leading) {
                                                   TextField("Payment Number", text: $paymentNumber)
                                                       .keyboardType(.numberPad)
                                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                                       .padding(5)
                                                   
                                                   
                                                   SecureField("CVC", text: $cvc)
                                                       .keyboardType(.numberPad)
                                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                                       .padding(5)
                                                   
                                                   TextField("Expiry Date (MM/YY)", text: $expiryDate)
                                                       .keyboardType(.numberPad)
                                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                                       .padding(5)
                                                       
                                               }
                                           }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Summary")
                            .font(.headline)
                            .foregroundColor(.brown)
                        HStack {
                            Text("Subtotal:")
                            Spacer()
                            Text("LKR \(String(format: "%.2f", totalPrice))")
                        }
                        HStack {
                            Text("Extra Tax:")
                            Spacer()
                            Text("LKR 0.00")
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
                    
                    Button(action: placeOrder) {
                        Text("Place the Order")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                    }
                    
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
                    
                    Image("banner2_home")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:380 ,height: 80)
                }
                .padding()
                .onAppear {
                    for index in selectedProducts.indices {
                        loadImage(for: index)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Order Confirmation"), message: Text("Your Order has been confirmed"), primaryButton: .default(Text("OK")), secondaryButton: .cancel())
                }
                .background(
                    NavigationLink(destination: AccountView(user: $createdUser, order: orderDetails,selectedProducts: $selectedProducts, email: email, password: password), isActive: $showAlert) {
                        EmptyView()
                    }
                    .hidden()
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $navigateToLogin) {
            LoginView(orderDetails: $orderDetails, selectedProducts: $selectedProducts, user: $createdUser)
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
                while index >= imageDatas.count {
                    imageDatas.append(nil)
                }
                imageDatas[index] = data
            }
        }.resume()
    }

    private func placeOrder() {
            let order = Order(orderNumber: nextOrderNumber,
                              fullName: fullName,
                              email: email,
                              streetAddress: streetAddress,
                              city: city,
                              postalCode: postalCode,
                              items: selectedProducts.map { $0.name },
                              totalNumberOfItems: totalNumberOfItems,
                              totalAmount: totalPrice,
                              cvc: cvc,
                              expiryDate: expiryDate)
            
            let apiClient = OrderAPIClient()
            apiClient.placeOrder(order: order) { error in
                if let error = error {
                    print("Error placing order: \(error.localizedDescription)")
                } else {
                    nextOrderNumber += 1
                    
                    DispatchQueue.main.async {
                        navigateToLogin = true
                        orderDetails = order
                    }
                }
            }
        }
    }



#Preview
{
    CheckoutView(selectedProducts: .constant([]), quantities: .constant([]))
}

