//
//  Ability.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/24/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Ability: String {
    enum Modifier {
        case str(modifier: Int)
        case dex(modifier: Int)
        case con(modifier: Int)
        case int(modifier: Int)
        case wis(modifier: Int)
        case cha(modifier: Int)
        
        init?(_ _mod: String) {
            let components = _mod.components(separatedBy: " ")
            guard components.count == 2 else { return nil }
            guard let modifier = Int(components[1]) else { return nil }
            switch components[0] {
            case "str": self = .str(modifier: modifier)
            case "dex": self = .dex(modifier: modifier)
            case "con": self = .con(modifier: modifier)
            case "int": self = .int(modifier: modifier)
            case "wis": self = .wis(modifier: modifier)
            case "cha": self = .cha(modifier: modifier)
            default: return nil
            }
        }
        
        var comparableValue: String {
            switch self {
            case .str: return "str"
            case .dex: return "dex"
            case .con: return "con"
            case .int: return "int"
            case .wis: return "wis"
            case .cha: return "cha"
            }
        }
        
        var modifier: Int {
            switch self {
            case .str(let modifier): return modifier
            case .dex(let modifier): return modifier
            case .con(let modifier): return modifier
            case .int(let modifier): return modifier
            case .wis(let modifier): return modifier
            case .cha(let modifier): return modifier
            }
        }
    }
    
    enum Score {
        case str(score: Int)
        case dex(score: Int)
        case con(score: Int)
        case int(score: Int)
        case wis(score: Int)
        case cha(score: Int)
        
        var comparableValue: String {
            switch self {
            case .str: return "str"
            case .dex: return "dex"
            case .con: return "con"
            case .int: return "int"
            case .wis: return "wis"
            case .cha: return "cha"
            }
        }
        
        var score: Int {
            switch self {
            case .str(let score): return score
            case .dex(let score): return score
            case .con(let score): return score
            case .int(let score): return score
            case .wis(let score): return score
            case .cha(let score): return score
            }
        }
        
        var modifier: Int {
            switch self {
            case .str(let score): return score.abilityModifier
            case .dex(let score): return score.abilityModifier
            case .con(let score): return score.abilityModifier
            case .int(let score): return score.abilityModifier
            case .wis(let score): return score.abilityModifier
            case .cha(let score): return score.abilityModifier
            }
        }
    }
    
    case str = "Strength"
    case dex = "Dexterity"
    case con = "Constitution"
    case int = "Intelligence"
    case wis = "Wisdom"
    case cha = "Charisma"
    
    var comparableValue: String {
        switch self {
        case .str: return "str"
        case .dex: return "dex"
        case .con: return "con"
        case .int: return "int"
        case .wis: return "wis"
        case .cha: return "cha"
        }
    }
    
    var shortTitle: String {
        return self.comparableValue.capitalized
    }
}

extension Array where Element == Ability.Score {
    subscript(_ ability: Ability) -> Ability.Score? {
        for _ability in self {
            if ability.comparableValue == _ability.comparableValue {
                return _ability
            }
        }
        return nil
    }
    
    subscript(_ savingThrow: SavingThrow) -> Ability.Score? {
        for _ability in self {
            if _ability.comparableValue == savingThrow.comparableValue {
                return _ability
            }
        }
        return nil
    }
    
    mutating func adding(_ modifiers: [Ability.Modifier]) {
        for (index, score) in self.enumerated() {
            switch score {
            case .str: self[index] = .str(score: score.score + (modifiers[.str]?.modifier ?? 0))
            case .dex: self[index] = .dex(score: score.score + (modifiers[.dex]?.modifier ?? 0))
            case .con: self[index] = .con(score: score.score + (modifiers[.con]?.modifier ?? 0))
            case .int: self[index] = .int(score: score.score + (modifiers[.int]?.modifier ?? 0))
            case .wis: self[index] = .wis(score: score.score + (modifiers[.wis]?.modifier ?? 0))
            case .cha: self[index] = .cha(score: score.score + (modifiers[.cha]?.modifier ?? 0))
            }
        }
    }
}

extension Array where Element == Ability.Modifier {
    subscript(_ ability: Ability) -> Ability.Modifier? {
        for modifier in self {
            if ability.comparableValue == modifier.comparableValue {
                return modifier
            }
        }
        return nil
    }
}

// MARK: - NPCGenAssist specific functionality
extension Array where Element == Ability.Modifier {
    func total() -> Int {
        var total: Int = 0
        for mod in self {
            total += mod.modifier
        }
        return total
    }
}
