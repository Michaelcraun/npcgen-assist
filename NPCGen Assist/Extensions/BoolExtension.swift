//
//  BoolExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/12/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

extension Bool {
    /// A String representation for the user.
    var userRepresentation: String {
        switch self {
        case false: return "NO"
        case true: return "YES"
        }
    }
    
    mutating func next() {
        switch self {
        case false: self = true
        case true: self = false
        }
    }
}
