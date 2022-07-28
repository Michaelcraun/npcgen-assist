//
//  CompendiumAction.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/25/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

extension Action: Equatable {
    static func == (lhs: Action, rhs: Action) -> Bool {
        return lhs.name == rhs.name && lhs._description == rhs._description
    }
}

struct Action: Codable, Identifiable {
    /// An enumeration of action types and their identifiers.
    enum ActionType: String {
        case melee = "Melee"
        case ranged = "Ranged"
        case thrown = "Melee or Ranged"
        
        init?(_ value: String) {
            switch value {
            case "melee": self = .melee
            case "ranged": self = .ranged
            case "thrown": self = .thrown
            default: return nil
            }
        }
    }
    
    /// The area of effect of an action.
    struct AreaOfEffect: Codable {
        var area: String
        var type: String
        
        var description: String {
            return "\(area) \(type)"
        }
    }

    /// An enumeration of damage types and their identifiers.
    enum DamageType: String, Codable {
        case acid
        case bludgeoning
        case cold
        case fire
        case force
        case lightning
        case necrotic
        case piercing
        case poison
        case psychic
        case radiant
        case slashing
        case thunder
    }
    
    /// The range of an action.
    struct Range: Codable {
        var short: Int
        var long: Int?
    }
    
    /// An enumeration of weapon types.
    enum WeaponType: Equatable {
        case martial(type: ActionType)
        case natural
        case none
        case simple(type: ActionType)
        
        init(_ description: String) {
            let components = description.components(separatedBy: "_")
            guard components.count > 1 else {
                switch components[0] {
                case "natural": self = .natural
                default: self = .none
                }
                return
            }
            
            guard let actionType = ActionType(components[1]) else {
                self = .none
                return
            }
            switch components[0] {
            case "martial": self = .martial(type: actionType)
            case "simple": self = .simple(type: actionType)
            default: self = .none
            }
        }
    }
    
    var _damageDie: String?
    var _damageType: String?
    var _weaponType: String?
    
    var identifier: String
    
    /// A textual representation of what the Action object does, if anything other that a simple attack.
    var _description: String?
    
    /// The AreaOfEffect object of the Action object, if any.
    var areaOfEffect: AreaOfEffect?
    
    /// A textual representation of the name of the the Action object.
    var name: String
    
    /// The reach of the weapon, if any.
    var reach: Int?
    
    /// The Range object assocatied with the weapon, if any.
    var range: Range?
    
    /// The SavingThrow object associated with the Action object, if any.
    var save: SavingThrow?
    
    /// A boolean value indicating if the Action can be used as both a one-handed and two-handed weapon.
    var versatile: Bool?
    
    /// The Die object associated with the weapon, if any.
    var damageDie: Die? {
        return Die(description: _damageDie ?? "")
    }
    
    /// The damage type associated with the weapon, if any.
    var damageType: DamageType? {
        return DamageType(rawValue: _damageType ?? "")
    }
    
    /// The weapon type associated with the weapon, if any.
    var weaponType: WeaponType? {
        return WeaponType(_weaponType ?? "")
    }
    
    init() {
        self._damageDie = "1d6"
        self._damageType = "bludgeoning"
        self._weaponType = "simpleMelee"
        self.identifier = String.autoID()
        self.name = "Shield Bash"
    }
    
    /// Creates a textual representation of what an attack does when the Action is a weapon.
    /// - Parameter npc: The NPC object to use when constructing the representation.
    func description(for npc: NPC) -> String? {
        guard let weaponType = weaponType else { return nil }
        switch weaponType {
        case .martial(let type), .simple(let type):
            switch type {
            case .melee:
                guard (versatile ?? false) == false else {
                    let versatilDie = damageDie!.next()
                    return "Melee Weapon Attack: $meleeAttackMod to hit, reach \(reach ?? 5) ft., one target. Hit: \(damageDie!.adding(npc.meleeDamageBonus)) (\(damageDie!.title) + \(npc.meleeDamageBonus)) \(damageType!.rawValue) damage. If wielded with two hands, this attack deals \(versatilDie.adding(npc.meleeDamageBonus)) (\(versatilDie.title) + \(npc.meleeDamageBonus)) \(damageType!.rawValue), instead."
                }
                return "Melee Weapon Attack: $meleeAttackMod to hit, reach \(reach ?? 5) ft., one target. Hit: \(damageDie!.adding(npc.meleeDamageBonus)) (\(damageDie!.title) + \(damageDie!.adding(npc.meleeDamageBonus))) \(damageType!.rawValue) damage."
            case .ranged:
                guard let damageDie = damageDie else {
                    return "Ranged Weapon Attack: $rangedAttackMod to hit, range \(range!.short)/\(range!.long!) ft., one target. Hit: \(1 + npc.rangedDamageBonus) \(damageType!.rawValue) damage."
                }
                return "Ranged Weapon Attack: $rangedAttackMod to hit, range \(range!.short)/\(range!.long!) ft., one target. Hit: \(damageDie.adding(npc.rangedDamageBonus) + npc.rangedDamageBonus) (\(damageDie.title) + \(npc.rangedDamageBonus)) \(damageType!.rawValue) damage."
            case .thrown:
                return "Melee or Ranged Weapon Attack: $meleeAttackMod to hit, reach \(reach ?? 5) ft. or range \(range!.short)/\(range!.long!), one target. Hit: \(damageDie!.adding(npc.meleeDamageBonus)) (\(damageDie!.title) + \(npc.meleeDamageBonus)) \(damageType!.rawValue) damage."
            }
        case .natural:
            return "Melee Weapon Attack: $meleeAttackModifier to hit, reach \(reach ?? 5) ft., one target. Hit: \(damageDie!.average) (\(damageDie!.adding(npc.meleeDamageBonus)) + \(damageDie!.adding(npc.meleeDamageBonus))) \(damageType!.rawValue) damage."
        case .none:
            var description = _description?.replacingOccurrences(of: "$areaOfEffect", with: areaOfEffect?.description ?? "")
            description = description?.replacingOccurrences(of: "$breathWeaponDamage", with: npc.progressiveDamageDice(using: .d6(numOfDice: 2)).title)
            description = description?.replacingOccurrences(of: "$damageType", with: damageType?.rawValue ?? "")
            
            return description
        }
    }
    
    /// Creates textual representations of a weapon attack to use when exporting an NPC object as an XML.
    /// - Parameter npc: The NPC object to use when constructinf the representations.
    func xmlRepresentations(for npc: NPC) -> (normal: String?, versatile: String?) {
        return (xmlRepresentation(for: npc), versatileXMLRepresentation(for: npc))
    }
    
    /// Creates a textual representation of what a normal attack to use when exporting an NPC object as an XML.
    /// - Parameter npc: The NPC object to use when constructinf the representations.
    private func xmlRepresentation(for npc: NPC) -> String? {
        guard let damageDie = damageDie, let weaponType = weaponType else { return nil }
        switch weaponType {
        case .martial(let type), .simple(let type):
            switch type {
            case .melee: return "\(name)|\(npc.meleeAttackModifier)|\(damageDie.title)\(npc.meleeDamageBonus.modifier)"
            case .ranged: return "\(name)|\(npc.rangedAttackModifier)|\(damageDie.title)\(npc.rangedDamageBonus.modifier)"
            case .thrown: return "\(name)|\(npc.meleeAttackModifier)|\(damageDie.title)\(npc.meleeDamageBonus.modifier)"
            }
        case .natural:
            return "\(name)|\(npc.meleeAttackModifier)|\(damageDie.title)\(npc.meleeDamageBonus.modifier)"
        case .none:
            return nil
        }
    }
    
    /// Creates a textual representation of what a versatile attack (if it is a versatile weapon) to use when exporting an NPC object as an XML.
    /// - Parameter npc: The NPC object to use when constructinf the representations.
    private func versatileXMLRepresentation(for npc: NPC) -> String? {
        guard versatile ?? false, let damageDie = damageDie?.next(), let weaponType = weaponType else { return nil }
        switch weaponType {
        case .martial(let type), .simple(let type):
            switch type {
            case .melee: return "\(name)|\(npc.meleeAttackModifier)|\(damageDie.title)\(npc.meleeDamageBonus.modifier)"
            case .ranged: return "\(name)|\(npc.rangedAttackModifier)|\(damageDie.title)\(npc.rangedDamageBonus.modifier)"
            case .thrown: return "\(name)|\(npc.meleeAttackModifier)|\(damageDie.title)\(npc.meleeDamageBonus.modifier)"
            }
        case .natural:
            return nil
        case .none:
            return nil
        }
    }
}

extension Array where Element == Action {
    /// A list of martial melee weapons contained within an Array of Action objects.
    var martialMeleeWeapons: [Action] {
        return self.filter({ $0.weaponType == .martial(type: .melee) })
    }
    
    /// A list of martial ranged weapons contained within an Array of Action objects.
    var martialRangedWeapons: [Action] {
        return self.filter({ $0.weaponType == .martial(type: .ranged) })
    }
    
    /// A list of martial weapons (both melee and ranged) contained within an Array of Action objects.
    var martialWeapons: [Action] {
        return martialMeleeWeapons + martialRangedWeapons
    }
    
    /// A list of melee weapons (both simple and martial) contained within an Array of Action objects.
    var meleeWeapons: [Action] {
        return simpleMeleeWeapons + martialMeleeWeapons
    }
    
    /// A list of ranged weapons (both simple and martial) contained within an Array of Action objects.
    var rangedWeapons: [Action] {
        return simpleRangedWeapons + martialRangedWeapons
    }
    
    /// A list of simple melee weapons contained within an Array of Action objects.
    var simpleMeleeWeapons: [Action] {
        return self.filter({ $0.weaponType == .simple(type: .melee) })
    }
    
    /// A list of simple ranged weapons contained within an Array of Action objects.
    var simpleRangedWeapons: [Action] {
        return self.filter({ $0.weaponType == .simple(type: .ranged) })
    }
    
    /// A list of simple weapons (both melee and ranged) contained within an Array of Action objects.
    var simpleWeapons: [Action] {
        return simpleMeleeWeapons + simpleRangedWeapons
    }
    
    /// A list of thrown weapons contained within an Array of Action objects.
    var thrownWeapons: [Action] {
        let simpleThrownWeapons = self.filter({ $0.weaponType == .simple(type: .thrown) })
        let martialThrownWeapons = self.filter({ $0.weaponType == .martial(type: .thrown) })
        return simpleThrownWeapons + martialThrownWeapons
    }
}
