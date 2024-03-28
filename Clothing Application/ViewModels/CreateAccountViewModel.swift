//
//  CreateAccountViewModel.swift
//  Clothing Application
//
//  Created by Ashini Dulashi on 2024-03-28.
//

import Foundation

class UserAPIClient {
    func createUser(user: User, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "http://localhost:3000/api/users") else {
            completion(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let _ = data, error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }.resume()
        } catch {
            completion(error)
        }
    }
}
