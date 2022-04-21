//
//  FirebaseAuthorization.swift
//  NPCGen5e
//
//  Created by Michael Craun on 1/26/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import AuthenticationServices
import CryptoKit

import FirebaseAuth

class FirebaseAuthorization: FirebaseManager {
    typealias AuthorizationCompletion = (_ user: User?, _ error: Error?) -> Void
    
    /// The currently signed in user, if any.
    var user: User?
    
    /// Obtains the currently signed in user, if able.
    func getCurrentUser() {
        self.user = User(Auth.auth().currentUser)
    }
    
    /// Signs a preeviously authorized user into the application using Firebase credentials, throwing an error if the user has not been previously authorized.
    /// - Parameters:
    ///   - email: The email used for signin.
    ///   - password: The password used for signin.
    ///   - completion: The completion handler that designates either a successful signin (user exists) or an unsuccessful signin (error exists).
    func signin(email: String, password: String, completion: @escaping AuthorizationCompletion) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            guard let error = error else {
                self.user = User(Auth.auth().currentUser)
                completion(self.user, nil)
                return
            }
            completion(nil, error)
        }
    }
}
