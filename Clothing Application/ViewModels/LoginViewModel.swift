//
//  LoginViewModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-29.
//

import Foundation

class LoginViewModel {
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/users/\(email)/\(password)") else {
            completion(.failure(NSError(domain: "Invalid API URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
