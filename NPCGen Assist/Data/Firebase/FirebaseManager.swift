//
//  FirebaseManager.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/25/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseKey {
    var key: String { get }
}

class FirebaseManager {
    enum Key: FirebaseKey {
        case characterDB
        case communityDB
        case coreDB
        case database
        case publicDB
        case userDB
        
        var key: String {
            switch self {
            case .characterDB: return "character"
            case .communityDB: return "community"
            case .coreDB: return "core"
            case .database: return "database"
            case .publicDB: return "public"
            case .userDB: return "users"
            }
        }
    }
    
    /// The public accessor of the FirebaseManager object.
    static let instance = FirebaseManager()
    
    /// Handles all authorization calls, such as login and signup.
    static let authorization = FirebaseAuthorization()
    
    /// Handles all calls related to the public compendium, such as initializing the compendium.
    static let compendium = FirebaseCompendium()
    
    /// The hard reference to the public database.
    var ref_database: DatabaseReference
    var ref_core: DatabaseReference
    
    init() {
        ref_database = Database.database().reference().child(Key.database.key)
        ref_core = ref_database.child(Key.coreDB.key)
    }
}
