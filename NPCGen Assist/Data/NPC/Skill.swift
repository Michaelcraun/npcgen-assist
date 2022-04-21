//
//  Shared.swift
//  NPCGenerator
//
//  Created by Michael Craun on 7/12/17.
//  Copyright © 2017 Craunic Productions. All rights reserved.
//

import Foundation

/// An enumeration of skills and their representations
enum Skill: String, CaseIterable {
    case acrobatics = "Acrobatics"
    case animalHandling = "Animal Handling"
    case arcana = "Arcana"
    case athletics = "Athletics"
    case deception = "Deception"
    case history = "History"
    case insight = "Insight"
    case intimidation = "Intimidation"
    case investigation = "Investigation"
    case medicine = "Medicine"
    case nature = "Nature"
    case perception = "Perception"
    case performance = "Performance"
    case persuasion = "Persuasion"
    case religion = "Religion"
    case sleightOfHand = "Sleight of Hand"
    case stealth = "Stealth"
    case survival = "Survival"
    
    static func generateSkillList(_ quantity: Int, with skillList: [Skill]) -> [Skill] {
        var _skillList = skillList
        var skills = [Skill]()
        
        for _ in 1..<quantity {
            let index = randomValue(upperBound: _skillList.count - 1)
            skills.append(_skillList[index])
            _skillList.remove(at: index)
        }
        return skills
    }
    
    // MARK: - New functions
    static func random(ignoring: [Skill]) -> Skill {
        let possibleSkills = Skill.allCases.removingExisting(ignoring)
        return possibleSkills.randomElement()!
    }
    
    func description(with abilityScores: [Ability.Score], and proficiency: Int) -> String {
        let bonus = abilityScores[self.ability]!.modifier + proficiency
        return "\(self.rawValue) \(bonus.modifier)"
    }
    
    /// The ability(s) associated with the given skill
    var ability: Ability {
        switch self {
        case .acrobatics: return .dex
        case .animalHandling: return .wis
        case .arcana: return .int
        case .athletics: return .str
        case .deception: return .cha
        case .history: return .int
        case .insight: return .wis
        case .intimidation: return .cha
        case .investigation: return .int
        case .medicine: return .wis
        case .nature: return .int
        case .perception: return .wis
        case .performance: return .cha
        case .persuasion: return .cha
        case .religion: return .int
        case .sleightOfHand: return .dex
        case .stealth: return .dex
        case .survival: return .wis
        }
    }
}

extension Array where Element == Skill {
    /// Sorts an array of Skill, according to the Skill's name.
    /// - returns: A sorted array of Skill.
    func sorted() -> [Skill] {
        return self.sorted(by: { (skill1, skill2) -> Bool in
            if skill1.rawValue == skill2.rawValue {
                return skill1.rawValue < skill2.rawValue
            } else {
                return skill1.rawValue < skill2.rawValue
            }
        })
    }
}
