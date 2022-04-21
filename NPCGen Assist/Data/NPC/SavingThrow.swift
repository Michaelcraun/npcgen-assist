//
//  SavingThrow.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/18/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import Foundation

enum SavingThrow: String, Codable {
    case str = "Str"
    case dex = "Dex"
    case con = "Con"
    case int = "Int"
    case wis = "Wis"
    case cha = "Cha"
    
    var comparableValue: String {
        return self.rawValue.lowercased()
    }
    
    func description(with abilityScores: [Ability.Score], and proficiency: Int) -> String {
        let bonus = abilityScores[self]!.modifier + proficiency
        return "\(rawValue) \(bonus.modifier)"
    }
}
