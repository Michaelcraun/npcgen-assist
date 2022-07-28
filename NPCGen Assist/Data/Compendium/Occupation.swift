//
//  CompendiumOccupation.swift
//  NPCGen5e_XMLTest
//
//  Created by Michael Craun on 3/30/19.
//  Copyright © 2019 BlackRoseProductions. All rights reserved.
//

import Foundation

class Occupation: Codable, Identifiable, Levelable {
    var _armorProficiencies: [String]?
    var _weaponProficiencies: [String]?
    
    var filterDescription: String
    var filterTitle: String
    var data: Compendium.LevelData?
    var identifier: String
    
    var lowChallenge: String?
    var highChallenge: String?
    
    /// A list of Armor objects that the Occupation object is proficient with.
    var armorProficiencies: [Armor] {
        let proficiencyTypes = (_armorProficiencies ?? []).compactMap({ Proficiency.ArmorType(rawValue: $0) })
        let typeArmors = proficiencyTypes.flatMap({ $0.armors })
        return (_armorProficiencies ?? []).compactMap({ Compendium.instance.armors[$0] }) + typeArmors
    }
    
    /// A list of weapons that the Occupation object is proficient with.
    var weaponProficiencies: [Action] {
        let proficiencyTypes = (_weaponProficiencies ?? []).compactMap({ Proficiency.Weapon(rawValue: $0) })
        let typeWeapons = proficiencyTypes.flatMap({ $0.weapons })
        return (_weaponProficiencies ?? []).compactMap({ Compendium.instance.weapons[$0] }) + typeWeapons
    }
    
    init() {
        self.filterDescription = ""
        self.filterTitle = ""
        self.identifier = ""
    }
    
    /// Constructs a ClosedRange of Challenge objects that the Occupation object can generate for filtration.
    /// - Parameters:
    ///   - lowLevel: The lowest level for generation.
    ///   - highLevel: The highest level for generation.
    func challengeRange(lowLevel: Int = 1, highLevel: Int = 20) -> ClosedRange<Challenge> {
        return lowestPossibleChallenge(at: lowLevel)...highestPossibleChallenge(at: highLevel)
    }
    
    /// Calculates the highest possible challenge for the Occupation object.
    /// - Parameter level: The level at which to calculate at.
    private func highestPossibleChallenge(at level: Int = 20) -> Challenge {
        var highestChallengeNPC = NPC(level: level, occupation: self)
        Compendium.instance.races.forEach ({
            let npc = NPC(level: level, occupation: self, race: $0)
            if npc.challenge > highestChallengeNPC.challenge {
                highestChallengeNPC = npc
            }
        })
        return highestChallengeNPC.challenge
    }
    
    /// Calculates the lowest possible challenge for the Occupation object.
    /// - Parameter level: The level at which to calculate at.
    private func lowestPossibleChallenge(at level: Int = 1) -> Challenge {
        var lowestChallengeNPC = NPC(level: level, occupation: self)
        Compendium.instance.races.forEach({
            let npc = NPC(level: level, occupation: self, race: $0)
            if npc.challenge < lowestChallengeNPC.challenge {
                lowestChallengeNPC = npc
            }
        })
        return lowestChallengeNPC.challenge
    }
}

// MARK: - NPCGen Assist specific functionality
extension Occupation {
    typealias ChallengeCompletion = () -> Void
    
    convenience init(name: String, description: String, armors: [String], weapons: [String], levelData: Compendium.LevelData) {
        self.init()
        self._armorProficiencies = armors
        self._weaponProficiencies = weapons
        self.data = levelData
        self.filterTitle = name.capitalized
        self.filterDescription = description
        self.identifier = name.lowercased()
    }
    
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
            let reference = FirebaseManager().ref_core.child("occupation").child(filterTitle.lowercased())
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
