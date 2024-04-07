//
//  CreateAccountView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-19.
//

import SwiftUI

struct CreateAccountView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var createdUser: User?
    @State private var orderDetails: Order?
    @Binding var selectedProducts: [Product]
    
    let userAPIClient = UserAPIClient()
    
    var body: some View {
        ZStack {
            Image("background_color")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Sign Up")
                    .font(.title)
                    .padding(.top, 50)
                
                Text("GlamCloth")
                    .font(.title)
                    .padding()
                    .fontWeight(.bold)
                
                Text("Clothing company")
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.top, -20)
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                
                Button(action: createAccount) {
                    Text("Create Account")
                        .foregroundColor(.black)
                }
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                NavigationLink(destination: LoginView(orderDetails: $orderDetails, selectedProducts: $selectedProducts, user: $createdUser)) {
                    Text("Already have an account? Sign In")
                        .foregroundColor(.black)
                }
                .padding()
            }
            .padding()
        }
        .background(
            NavigationLink(
                destination: AccountView(user: $createdUser, order: orderDetails,selectedProducts: $selectedProducts, email: email, password: password),
                isActive: Binding<Bool>(
                    get: { self.createdUser != nil },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    struct CustomTextFieldStyle: TextFieldStyle {
        func _body(configuration: TextField<_Label>) -> some View {
            configuration
                .padding(.horizontal)
                .frame(height: 40)
                .background(Color.clear)
                .foregroundColor(.black)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1))
        }
    }
    
    func createAccount() {
        guard !firstName.isEmpty else {
            alertMessage = "Please enter your first name."
            showAlert = true
            return
        }
        guard !lastName.isEmpty else {
            alertMessage = "Please enter your last name."
            showAlert = true
            return
        }
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }
        guard !password.isEmpty else {
            alertMessage = "Please enter a password."
            showAlert = true
            return
        }
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        let newUser = User(firstName: firstName, lastName: lastName, email: email, password: password)
        
        userAPIClient.createUser(user: newUser) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            } else {
                print("User account created successfully")
                self.createdUser = newUser
            }
        }
    }
}
