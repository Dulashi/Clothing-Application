//
//  LoginView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-19.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isAccountViewActive = false
    @State private var isCreateAccountViewActive = false
    @State private var isRecoveryLinkSent = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    
    let loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("My Account")
                    .font(.title)
                    .padding(.top, 50)
                
                Text("GlamCloth")
                    .font(.title)
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: signIn) {
                    Text("Sign In")
                }
                .padding()
                
                Button(action: {
                    isRecoveryLinkSent.toggle()
                }) {
                    Text("Forgot password?")
                }
                .sheet(isPresented: $isRecoveryLinkSent, content: {
                    ForgotPasswordView(isPresented: $isRecoveryLinkSent, email: $email)
                })
                
                Spacer()
                
                NavigationLink(destination: HomeView(), isActive: $isAccountViewActive) {
                    EmptyView()
                }
                
                NavigationLink(destination: CreateAccountView(), isActive: $isCreateAccountViewActive) {
                    Button(action: {
                        isCreateAccountViewActive.toggle()
                    }) {
                        Text("Don't have an account? Create Account")
                    }
                    .padding()
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                if alertMessage == "Login Successful" {
                    return Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    func signIn() {
        loginViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                if user.email == email && user.password == password {
                  
                    DispatchQueue.main.async {
                        isAccountViewActive = true
                        alertMessage = "Login Successful"
                        showAlert = true
                    }
                } else {
                   
                    DispatchQueue.main.async {
                        alertMessage = "Incorrect email or password"
                        showAlert = true
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    alertMessage = "An error occurred while signing in. Please try again later."
                    showAlert = true
                }
            }
        }
    }
}

struct ForgotPasswordView: View {
    @Binding var isPresented: Bool
    @Binding var email: String
    
    var body: some View {
        VStack {
            Text("Enter your email to receive a recovery link")
                .padding()
            
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                isPresented.toggle()
            }) {
                Text("Send")
            }
            .padding()
            
            Button(action: {
                isPresented.toggle()
            }) {
                Text("Cancel")
            }
            .padding()
        }
    }
}
