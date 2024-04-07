//
//  AccountView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-19.
//

import SwiftUI

struct AccountView: View {
    let user: Binding<User?>
    let order: Order?
    @Binding var selectedProducts: [Product]
    let email: String
    let password: String
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image("logout")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 20 ,height: 20)
                        .padding(.bottom, 78)
                        .offset(x: 340, y: -0.90)
                    
                    Text("My Account")
                        .font(.title)
                        .offset(x: 90, y: -10)
                    
                    Spacer()
                }
                
                Image("discount_bar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .padding(.top, -70)
                
                HStack {
                    Image("Account_image_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .offset(x: -40, y: -55)
                    
                        Text("Account Details")
                            .font(.system(size: 15, weight: .bold))
                            .offset(x: -40, y: -55)
                        
                        VStack(alignment: .leading) {
                        if let user = user.wrappedValue {
                            Text("First Name: \(user.firstName)")
                                .font(.system(size: 12))
                                .offset(x: -170, y: 10)
                            Text("Last Name: \(user.lastName)")
                                .font(.system(size: 12))
                                .offset(x: -170, y: 15)
                            Text("Email: \(user.email)")
                                .font(.system(size: 12))
                                .offset(x: -170, y: 20)
                               
                        } else {
                            Text("No account")
                                .font(.system(size: 12))
                                .offset(x: -70, y: 10)
                        
                        }
                    }
                }
                
                .frame(width:380, height: 160)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Order History")
                        .font(.system(size: 15, weight: .bold))
                        .padding(.bottom, 10)
                    
                    if let order = order {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Order Number: \(order.orderNumber)")
                                .font(.system(size: 12))
                            Text("Full Name: \(order.fullName)")
                                .font(.system(size: 12))
                            Text("Email: \(order.email)")
                                .font(.system(size: 12))
                            Text("Items: \(order.items.joined(separator: "\n"))")
                                .font(.system(size: 12))
                            Text("Total no. of Items: \(order.totalNumberOfItems)")
                                .font(.system(size: 12))
                            Text("Total Amount: \(order.totalAmount)")
                                .font(.system(size: 12))
                        }
                    } else {
                        Text("No orders placed")
                            .font(.system(size: 12))
                    }
                }
                .offset(x: -50, y: -100)
                .frame(width: 380, height: 500)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.gray.opacity(0.1))
                )
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        
        BottomNavigationPanel(selectedProducts: $selectedProducts, email: email, password: password)
    }
    
}

