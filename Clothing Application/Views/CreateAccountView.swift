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
    
    // Instantiate UserAPIClient
    let userAPIClient = UserAPIClient()
    
    var body: some View {
        VStack {
            Text("My Account")
                .font(.title)
                .padding(.top, 50)
            
            Text("GlamCloth")
                .font(.title)
                .padding()
            
            TextField("First Name", text: $firstName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Last Name", text: $lastName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: createAccount) {
                Text("Create Account")
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            NavigationLink(destination: LoginView()) {
                Text("Already have an account? Sign In")
            }
            .padding()
        }
        .padding()
    }
    
    func createAccount() {
        // Basic validation checks
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
        
        // Create a User object with the entered data
        let newUser = User(firstName: firstName, lastName: lastName, email: email, password: password)
        
        // Call the API to save the user data
        userAPIClient.createUser(user: newUser) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
                showAlert = true
            } else {
                // Optionally, perform navigation or other actions upon successful account creation
                print("User account created successfully")
            }
        }
    }
}
