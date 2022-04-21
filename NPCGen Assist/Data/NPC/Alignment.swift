//
//  Alignment.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Alignment: String, CaseIterable, Codable {
    case lawfulGood = "lawfulgood"
    case lawfulNeutral = "lawfulneutral"
    case lawfulEvil = "lawfulevil"
    case neutralGood = "neutralgood"
    case neutral = "neutral"
    case neutralEvil = "neutralevil"
    case chaoticGood = "chaoticgood"
    case chaoticNeutral = "chaoticneutral"
    case chaoticEvil = "chaoticevil"
    
    static func random() -> Alignment {
        return Alignment.allCases.randomElement()!
    }
    
    var descriptor: String {
        switch self {
        case .lawfulGood:       return "lawful good"
        case .lawfulNeutral:    return "lawful neutral"
        case .lawfulEvil:       return "lawful evil"
        case .neutralGood:      return "neutral good"
        case .neutral:          return "neutral"
        case .neutralEvil:      return "neutral evil"
        case .chaoticGood:      return "chaotic good"
        case .chaoticNeutral:   return "chaotic neutral"
        case .chaoticEvil:      return "chaotic evil"
        }
    }
}
