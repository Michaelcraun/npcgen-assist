//
//  Gender.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Gender: Int, CaseIterable, Codable {
    case female
    case male
    
    static func random() -> Gender {
        return Gender.allCases.randomElement()!
    }
    
    var descriptor: String {
        switch self {
        case .female: return "female"
        case .male: return "male"
        }
    }
    
    var pronoun: String {
        switch self {
        case .female: return "she"
        case .male: return "he"
        }
    }
    
    var alternatePronoun: String {
        switch self {
        case .female: return "her"
        case .male: return "his"
        }
    }
}
