//
//  User.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import UIKit
import AuthenticationServices

import Firebase

class User: Codable {
    private var email: String?
    private var first: String?
    private var last: String?
    private var photo: String?
    private var uid: String?
    private var username: String?
    private var refs: [String]?
    
    // MARK: - Public accessors
    var fullName: String {
        guard let first = first, let last = last else { return username ?? email ?? "" }
        return "\(first) \(last)"
    }
    
    var id: String {
        return uid ?? UUID().uuidString
    }
    
    init(user: User? = nil) {
        self.email = user?.email
        self.first = user?.first
        self.last = user?.last
        self.photo = user?.photo
        self.uid = user?.uid
        self.username = user?.username
    }
    
    convenience init?(_ user: FirebaseAuth.User?) {
        guard let user = user else { return nil }
        self.init()
        self.email = user.email ?? ""
        self.uid = user.uid
    }
    
    convenience init?(_ snapshot: DataSnapshot) throws {
        guard let value = snapshot.value as? [String : Any] else { return nil }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
            let user = try JSONDecoder().decode(User.self, from: data)
            self.init(user: user)
        } catch let error {
            throw error
        }
    }
}
