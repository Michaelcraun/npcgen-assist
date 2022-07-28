//
//  CompendiumRace.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/25/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Race: Codable, Identifiable, Levelable {
    var _abilityModifiers: [String]?
    var _damageResistances: [String]?
    var _languages: [String]?
    var _size: String
    var _skills: [String]?
    var _specialFeatures: [String]?
    var _subraces: [String]?
    var _weaponProficiencies: [String]?
    var familyNames: [String]?
    var femaleNames: [String]?
    var maleNames: [String]?
    
    var data: Compendium.LevelData?
    var filterDescription: String
    var filterTitle: String
    var identifier: String
    
    var lowChallenge: String?
    var highChallenge: String?
    
    /// A list of challenge modifiers associated with the Race object, if any.
    var _challengeModifiers: [String]?
    
    /// The range of darkvision associated with the Race object.
    var darkvision: Int
    
    /// The name of the Race object.
    var name: String
    
    /// The land speed of the Race object.
    var speed: Int
    
    /// A list of modifiers to be used when caclulating ability scores.
    var abilityModifiers: [Ability.Modifier] {
        return (_abilityModifiers ?? []).compactMap({ Ability.Modifier($0) })
    }
    
    /// A list of Action.DamageType objects that the Race object is resistant to.
    var damageResistances: [Action.DamageType] {
        return (_damageResistances ?? []).compactMap({ Action.DamageType(rawValue: $0) })
    }
    
    /// A list of languages that the Race object can speak, read, and write.
    var languages: [Language] {
        return (_languages ?? []).compactMap({ Language(rawValue: $0) })
    }
    
    /// The size of the Race object.
    var size: Size {
        return Size(rawValue: _size) ?? .medium
    }
    
    /// A list of skills that the Race object is proficient in.
    var skills: [Skill] {
        return (_skills ?? []).compactMap({ Skill(rawValue: $0) })
    }
    
    /// A list of Subrace objects that are "contained" within a Race object used when initializing an NPC object.
    var subraces: [Subrace] {
        return (_subraces ?? []).compactMap({ Compendium.instance.subraces[$0] })
    }
    
    /// A list of Compendium.SpecialFeature objects that pertain to the Subrace object.
    var specialFeatures: [Compendium.SpecialFeature] {
        return (_specialFeatures ?? []).compactMap({ Compendium.SpecialFeature(rawValue: $0) })
    }
    
    /// A list of Action objects that represent any weapons the Subrace object is proficient in.
    var weaponProficiencies: [Action] {
        return (_weaponProficiencies ?? []).compactMap({ Compendium.instance.weapons[$0] })
    }
    
    /// Selects a random element from the *femaleNames* or *maleNames* property, depending on the designated gender.
    /// - Parameter gender: The Gender object used to determine which list of names to use when selecting a name.
    func firstName(for gender: Gender) -> String {
        return gender == .female ? femaleNames!.randomElement()! : maleNames!.randomElement()!
    }
    
    /// A random last name from the *familyNames* property.
    func lastName() -> String? {
        guard let familyNames = familyNames, familyNames.count > 0 else { return nil }
        return familyNames.randomElement()!
    }
    
    /// Constructs a ClosedRange of Challenge objects that the Race object can generate for filtration.
    /// - Parameters:
    ///   - lowLevel: The lowest level for generation.
    ///   - highLevel: The highest level for generation.
    func challengeRange(lowLevel: Int = 1, highLevel: Int = 20) -> ClosedRange<Challenge> {
        return lowestPossibleChallenge(at: lowLevel)...highestPossibleChallenge(at: highLevel)
    }
    
    /// Calculates the highest possible challenge for the Race object.
    /// - Parameter level: The level at which to calculate at.
    private func highestPossibleChallenge(at level: Int = 20) -> Challenge {
        var highestChallengeNPC = NPC(level: level, race: self)
        Compendium.instance.occupations.forEach({
            let npc = NPC(level: level, occupation: $0, race: self)
            if npc.challenge > highestChallengeNPC.challenge {
                highestChallengeNPC = npc
            }
        })
        return highestChallengeNPC.challenge
    }
    
    /// Calculates the lowest possible challenge for the Occupation object.
    /// - Parameter level: The level at which to calculate at.
    private func lowestPossibleChallenge(at level: Int = 1) -> Challenge {
        var lowestChallengeNPC = NPC(level: level, race: self)
        Compendium.instance.occupations.forEach({
            let npc = NPC(level: level, occupation: $0, race: self)
            if npc.challenge < lowestChallengeNPC.challenge {
                lowestChallengeNPC = npc
            }
        })
        return lowestChallengeNPC.challenge
    }
    
    struct Subrace: Codable, Identifiable, Levelable {
        var _abilityModifiers: [String]?
        var _actions: [String]?
        var _armorProficiencies: [String]?
        var _damageResistances: [String]?
        var _specialFeatures: [String]?
        var _weaponProficiencies: [String]?
        
        var data: Compendium.LevelData?
        var identifier: String
        
        /// A list of challenge modifiers associated with the Subrace object, if any.
        var _challengeModifiers: [String]?
        
        /// The range of darkvision associated with the Subrace object.
        var darkvision: Int
        
        /// A list of last names associated with the Subrace object.
        var familyNames: [String]
        
        /// A list of female names associated with the Subrace object.
        var femaleNames: [String]
        
        /// A list of male names associated with the Subrace object.
        var maleNames: [String]
        
        /// The name of the Subrace object.
        var name: String
        
        /// The identifier of the parent Race object associated with the Subracee object.
        var race: String
        
        /// The modifier to be applied to land speed.
        var speed: Int
        
        /// A list of modifiers to be used when caclulating ability scores.
        var abilityModifiers: [Ability.Modifier] {
            return (_abilityModifiers ?? []).compactMap({ Ability.Modifier($0) })
        }
        
        /// A list of Action objects associated with the Subrace object.
        var actions: [Action] {
            return (_actions ?? []).compactMap({ Compendium.instance.actions[$0] })
        }
        
        /// A list of Armor objects that the Subrace object is proficient in.
        var armorProficiencies: [Armor] {
            let proficiencyTypes = (_armorProficiencies ?? []).compactMap({ Proficiency.ArmorType(rawValue: $0) })
            let typeArmors = proficiencyTypes.flatMap({ $0.armors })
            return (_armorProficiencies ?? []).compactMap({ Compendium.instance.armors[$0] }) + typeArmors
        }
        
        /// A list of Action.DamageType objects that the Subrace object is resistant to.
        var damageResistances: [Action.DamageType] {
            return (_damageResistances ?? []).compactMap({ Action.DamageType(rawValue: $0) })
        }
        
        /// A random last name from the *familyNames* property.
        var lastName: String? {
            return familyNames.randomElement()
        }
        
        /// A list of Compendium.SpecialFeature objects that pertain to the Subrace object.
        var specialFeatures: [Compendium.SpecialFeature] {
            return (_specialFeatures ?? []).compactMap({ Compendium.SpecialFeature(rawValue: $0) })
        }
        
        /// A list of Action objects that represent any weapons the Subrace object is proficient in.
        var weaponProficiencies: [Action] {
            return (_weaponProficiencies ?? []).compactMap({ Compendium.instance.weapons[$0] })
        }
        
        /// Selects a random element from the *femaleNames* or *maleNames* property, depending on the designated gender.
        /// - Parameter gender: The Gender object used to determine which list of names to use when selecting a name.
        func firstName(for gender: Gender) -> String {
            return gender == .female ? femaleNames.randomElement()! : maleNames.randomElement()!
        }
    }
}

extension Race {
    typealias ChallengeCompletion = () -> Void
    
    func update(challenge rating: Challenge, completion: @escaping ChallengeCompletion) {
        let currentLow = lowChallenge
        let currentHigh = highChallenge
        
        if let low = lowChallenge, let challenge = Challenge(rawValue: low) {
            if rating < challenge {
                self.lowChallenge = rating.rawValue
            }
        } else {
            self.lowChallenge = rating.rawValue
        }
        
        if let high = highChallenge, let challenge = Challenge(rawValue: high) {
            if rating > challenge {
                self.highChallenge = rating.rawValue
            }
        } else {
            self.highChallenge = rating.rawValue
        }
        
        if currentLow == self.lowChallenge && currentHigh == self.highChallenge {
            return completion()
        }
        
        do {
            let encoded = try JSONEncoder().encode(self)
            guard let json = try JSONSerialization.jsonObject(with: encoded) as? [String : Any] else {
                print("nil json")
                return completion()
            }
            let reference = FirebaseManager().ref_core.child("race").child(filterTitle.lowercased())
            reference.setValue(json) { error, ref in
                if let error = error {
                    print(error.localizedDescription)
                }
                completion()
            }
        } catch let error {
            print(error)
            completion()
        }
    }
}
