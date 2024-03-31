//
//  AccountView.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-19.
//

import SwiftUI

struct AccountView: View {
    let loginViewModel = LoginViewModel()
    let email: String
    let password: String 
    @State private var user: User?

    var body: some View {
        VStack {
            if let user = user {
                Text("First Name: \(user.firstName)")
                Text("Last Name: \(user.lastName)")
                Text("Email: \(user.email)")
            } else {
                ProgressView()
                    .onAppear(perform: signInAndFetchUserDetails)
            }
        }
    }

    private func signInAndFetchUserDetails() {
        loginViewModel.signIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print("Error signing in and fetching user details: \(error)")
            }
        }
    }
}

