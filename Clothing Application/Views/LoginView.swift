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
    @State private var createdUser: User?
    @Binding var orderDetails: Order?
    @Binding var selectedProducts: [Product]
    
    
    let user: Binding<User?>
    let loginViewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Image("background_color")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Sign In")
                        .font(.title)
                        .padding(.top, 70)
                        .foregroundColor(.black)
                    
                    Text("GlamCloth")
                        .font(.title)
                        .padding()
                        .fontWeight(.bold)
                    
                    Text("Clothing company")
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.top, -20)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .padding()
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                        .padding()
                    
                    Button(action: signIn) {
                        Text("Sign In")
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    Button(action: {
                        isRecoveryLinkSent.toggle()
                    }) {
                        Text("Forgot password?")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $isRecoveryLinkSent, content: {
                        ForgotPasswordView(isPresented: $isRecoveryLinkSent, email: $email)
                    })
                    
                    Spacer()
                    
                    NavigationLink(destination: AccountView(user: $createdUser, order: orderDetails,selectedProducts: $selectedProducts, email: email, password: password), isActive: $isAccountViewActive) {
                        EmptyView()
                        }
                    
                    NavigationLink(destination: CreateAccountView(selectedProducts: $selectedProducts), isActive: $isCreateAccountViewActive) {
                        Button(action: {
                            isCreateAccountViewActive.toggle()
                        }) {
                            Text("Don't have an account? Create Account")
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                }
                .padding()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .alert(isPresented: $showAlert) {
                    if alertMessage == "Login Successful. Thank you for signing in!" {
                        return Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                            isAccountViewActive = true
                            
                        })
                    } else {
                        return Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
    }
    
    func signIn() {
        loginViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                if user.email == email && user.password == password {
                    DispatchQueue.main.async {
                        createdUser = user 
                        alertMessage = "Login Successful. Thank you for signing in!"
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
                    alertMessage = "Login Failed: \(error.localizedDescription)"
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
