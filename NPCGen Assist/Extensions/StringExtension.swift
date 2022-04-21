//
//  StringExtension.swift
//  NPCGen5e_XMLTest
//
//  Created by Michael Craun on 4/1/19.
//  Copyright © 2019 BlackRoseProductions. All rights reserved.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    
    static func autoID(length: Int = 28) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var id = ""
        
        for _ in 0..<28 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            id += NSString(characters: &nextChar, length: 1) as String
        }
        return id
    }
    
    static func random(length: Int = 20) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func asDouble() -> Double {
        if self.contains("/") {
            let components = self.components(separatedBy: "/")
            let numerator = Double(components[0])!
            let denominator = Double(components[1])!
            return numerator / denominator
        } else {
            return Double(self)!
        }
    }
    
    func replacingPlaceholders(with npc: NPC) -> String {
        // Names and designations
        var newString = self.replacingOccurrences(of: "$name", with: npc.name)
        newString = newString.replacingOccurrences(of: "$shortName", with: npc.shortName)
        newString = newString.replacingOccurrences(of: "$possessiveName", with: "\(npc.shortName)'s")
        newString = newString.replacingOccurrences(of: "$alternatePronoun", with: npc.gender.alternatePronoun)
        newString = newString.replacingOccurrences(of: "$pronoun", with: npc.gender.pronoun)
        newString = newString.replacingOccurrences(of: "$capsPronoun", with: npc.gender.pronoun.capitalized)
        
        // Statistics
        newString = newString.replacingOccurrences(of: "$level", with: "\(npc.level)")
        
        // Spell statistics
        newString = newString.replacingOccurrences(of: "$chaSpell", with: npc.spellDescription(.cha))
        newString = newString.replacingOccurrences(of: "$conSpell", with: npc.spellDescription(.con))
        newString = newString.replacingOccurrences(of: "$dexSpell", with: npc.spellDescription(.con))
        newString = newString.replacingOccurrences(of: "$intSpell", with: npc.spellDescription(.int))
        newString = newString.replacingOccurrences(of: "$strSpell", with: npc.spellDescription(.con))
        newString = newString.replacingOccurrences(of: "$wisSpell", with: npc.spellDescription(.wis))
        
        // Saving throws
        newString = newString.replacingOccurrences(of: "$chaSave", with: "\(npc.saveDCValue(.cha)) Charisma saving throw")
        newString = newString.replacingOccurrences(of: "$conSave", with: "\(npc.saveDCValue(.con)) Constitution saving throw")
        newString = newString.replacingOccurrences(of: "$dexSave", with: "\(npc.saveDCValue(.dex)) Dexterity saving throw")
        newString = newString.replacingOccurrences(of: "$intSave", with: "\(npc.saveDCValue(.int)) Intelligence saving throw")
        newString = newString.replacingOccurrences(of: "$strSave", with: "\(npc.saveDCValue(.str)) Strength saving throw")
        newString = newString.replacingOccurrences(of: "$wisSave", with: "\(npc.saveDCValue(.wis)) Wisdom saving throw")
        
        // Attack statistics
        newString = newString.replacingOccurrences(of: "$meleeAttackMod", with: npc.meleeAttackModifier.modifier)
        newString = newString.replacingOccurrences(of: "$meleeDamageMod", with: "\(npc.meleeDamageBonus)")
        newString = newString.replacingOccurrences(of: "$rangedAttackMod", with: npc.rangedAttackModifier.modifier)
        newString = newString.replacingOccurrences(of: "$rangedDamageMod", with: "\(npc.rangedDamageBonus)")
        
        return newString
    }
    
    func removingCharacters(_ characters: [Character]) -> String {
        var newString = ""
        for char in self {
            if !characters.contains(char) {
                newString.append(char)
            }
        }
        return newString
    }
    
    func removingLast(_ count: Int) -> String {
        let length = self.count - count
        return String(self[0...length])
    }
}
