//
//  Proficiency.swift
//  NPCGen5e
//
//  Created by Michael Craun on 10/26/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Proficiency {
    enum ArmorType: String {
        case light
        case medium
        case heavy
        case shield
        
        var armors: [Armor] {
            switch self {
            case .light: return Compendium.instance.armors.lightArmors
            case .medium: return Compendium.instance.armors.mediumArmors
            case .heavy: return Compendium.instance.armors.heavyArmors
            case .shield: return Compendium.instance.armors.shields
            }
        }
    }
    
    enum Weapon: String {
        case exotic
        case martial
        case martialMelee
        case martialRanged
        case melee
        case ranged
        case simple
        case simpleMelee
        case simpleRanged
        
        var weapons: [Action] {
            switch self {
            case .exotic: return []
            case .martial: return Compendium.instance.weapons.martialWeapons
            case .martialMelee: return Compendium.instance.weapons.martialMeleeWeapons
            case .martialRanged: return Compendium.instance.weapons.martialRangedWeapons
            case .melee: return Compendium.instance.weapons.meleeWeapons
            case .ranged: return Compendium.instance.weapons.rangedWeapons
            case .simple: return Compendium.instance.weapons.simpleWeapons
            case .simpleMelee: return Compendium.instance.weapons.simpleMeleeWeapons
            case .simpleRanged: return Compendium.instance.weapons.simpleRangedWeapons
            }
        }
    }
}
