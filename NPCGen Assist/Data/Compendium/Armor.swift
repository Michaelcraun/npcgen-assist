//
//  CompendiumArmor.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/25/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

struct Armor: Codable, Identifiable {
    /// An enumeration of armor types and their identifiers.
    enum ArmorType: String, Codable {
        case none
        case light
        case medium
        case heavy
        case shield
    }
    
    private var _type: String
    
    var identifier: String
    
    /// The Armor object's unmodified armor class.
    var baseAC: Int
    
    /// The Armor object's name.
    var name: String
    
    /// The Armor object's type.
    var type: ArmorType {
        return ArmorType(rawValue: _type) ?? .none
    }
    
    /// Calculates the Armor object's actual armor class, using a list of Ability.Score objects.
    /// - Parameter abilityScores: An NPC object's Array of Ability.Score objects.
    func armorClass(with abilityScores: [Ability.Score]) -> Int {
        let dexModifier = abilityScores[Ability.dex]!.modifier
        let conModifier = abilityScores[Ability.con]!.modifier
        switch type {
        case .heavy: return baseAC
        case .light: return baseAC + dexModifier
        case .medium: return dexModifier <= 2 ? baseAC + dexModifier : baseAC + 2
        case .none: return baseAC + dexModifier + conModifier
        case .shield: return 0
        }
    }
}

extension Array where Element == Armor {
    /// Constructs a list of Armor objects that a creaturee can equip.
    /// - Parameter types: The list of Armor.ArmorType objects that the NPC object can equip.
    func equippable(types: [Armor.ArmorType]) -> [Armor] {
        return self.filter({ types.contains($0.type) })
    }
    
    /// A list of light armors contained within an Array of Armor objects.
    var lightArmors: [Armor] {
        return self.filter({ $0.type == .light })
    }
    
    /// A list of medium armors contained within an Array of Armor objects.
    var mediumArmors: [Armor] {
        return self.filter({ $0.type == .medium })
    }
    
    /// A list of heavy armors contained within an Array of Armor objects.
    var heavyArmors: [Armor] {
        return self.filter({ $0.type == .heavy })
    }
    
    /// A list of shields contained within an Array of Armor objects.
    var shields: [Armor] {
        return self.filter({ $0.type == .shield })
    }
}
