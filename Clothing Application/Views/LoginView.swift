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
                
                NavigationLink(destination: AccountView(), isActive: $isAccountViewActive) {
                                    Button(action: {
                                        isAccountViewActive.toggle()
                                    }) {
                                        Text("Sign In")
                                    }
                    .padding()
                }
                
                Button(action: {
                    isRecoveryLinkSent.toggle()
                }) {
                    Text("Forgot password?")
                }
                .sheet(isPresented: $isRecoveryLinkSent, content: {
                    ForgotPasswordView(isPresented: $isRecoveryLinkSent, email: $email)
                })
                
                Spacer()
                
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
            .navigationTitle("")
            .navigationBarHidden(true)
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
#Preview {
    LoginView()
}

