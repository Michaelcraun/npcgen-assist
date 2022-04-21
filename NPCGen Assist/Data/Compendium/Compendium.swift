//
//  Compendium.swift
//  NPCGen5e_XMLTest
//
//  Created by Michael Craun on 3/30/19.
//  Copyright © 2019 BlackRoseProductions. All rights reserved.
//

import Foundation

protocol Debuggable {
    var debugDescription: String { get }
}

protocol Identifiable {
    /// The unique identifier of the object.
    var identifier: String { get set }
}

extension Array where Element: Identifiable {
    subscript<T: Identifiable>(_ identifier: String) -> T? {
        return self.filter({ $0.identifier == identifier }).first as? T
    }
}

protocol Levelable {
    /// The level data of a specific object.
    var data: Compendium.LevelData? { get set }
}

class Compendium: Codable {
    /// An enumeration of challenge modifiers.
    enum ChallengeModifier {
        /// An enumeration of operations indicating what should be done with the ChallengeModifier object's *modifier* property.
        enum Operation: String {
            case add = "+"
            case divide = "/"
            case equals = "="
            case multiply = "*"
            case subtract = "-"
        }
        
        /// The type of modifier being constructed that indicates what type of data that should be modified.
        enum ModifierType {
            case armorClass
            case attackBonus
            case damagePerRound
            case hitPoints
        }
        
        case armorClass(operation: Operation, modifier: Int)
        case attackBonus(operation: Operation, modifier: Int)
        case damagePerRound(operation: Operation, modifier: Int)
        case hitPoints(operation: Operation, modifier: Int)
        
        init?(_ description: String, level: Int, abilityScores: [Ability.Score]) {
            var descriptionComponents = description.components(separatedBy: " ")
            let identifier = descriptionComponents.removeFirst()
            var formula = descriptionComponents.map({ "\($0) " }).joined().removingLast(2)
            guard let operand = Operation(rawValue: String(formula.removeFirst())) else { return nil }
            
            if let simpleModifier = Int(formula) {
                switch identifier {
                case "armorClass": self = .armorClass(operation: operand, modifier: simpleModifier)
                case "attackBonus": self = .attackBonus(operation: operand, modifier: simpleModifier)
                case "damagePerRound": self = .damagePerRound(operation: operand, modifier: simpleModifier)
                case "hitPoints": self = .hitPoints(operation: operand, modifier: simpleModifier)
                default: return nil
                }
            } else {
                let wisModifier = abilityScores[Ability.wis]!.modifier
                formula = formula.replacingOccurrences(of: "level", with: "\(level)")
                formula = formula.replacingOccurrences(of: "wis", with: "\(wisModifier)")
                let expression = NSExpression(format: formula)
                guard let modifier = expression.expressionValue(with: nil, context: nil) as? Int else { return nil }
                
                switch identifier {
                case "armorClass": self = .armorClass(operation: operand, modifier: modifier)
                case "attackBonus": self = .attackBonus(operation: operand, modifier: modifier)
                case "damagePerRound": self = .damagePerRound(operation: operand, modifier: modifier)
                case "hitPoints": self = .hitPoints(operation: operand, modifier: modifier)
                default: return nil
                }
            }
        }
        
        /// An integer representing the modifier of the ChallengeModifier object.
        var modifier: Int {
            switch self {
            case .armorClass(_, let modifier), .attackBonus(_, let modifier), .damagePerRound(_, let modifier), .hitPoints(_, let modifier):
                return modifier
            }
        }
        
        /// The Operation that should be completed with the ChallengeModifier's *modifier* property.
        var operation: Operation {
            switch self {
            case .armorClass(let operation, _), .attackBonus(let operation, _), .damagePerRound(let operation, _), .hitPoints(let operation, _): return operation
            }
        }
        
        /// The ModifierType representing what data should be modified by the ChallengeModifier.
        var type: ModifierType {
            switch self {
            case .armorClass: return .armorClass
            case .attackBonus: return .attackBonus
            case .damagePerRound: return .damagePerRound
            case .hitPoints: return .hitPoints
            }
        }
    }
    
    /// An enumeration of special features that an occupation, race, or subrace may have.
    enum SpecialFeature: String {
        case abilityPlusOne
        case dwarvenToughness
        case extraLanguage
        case skillVersatility
    }
    
    /// A traversable collection of data that changes dependent on an NPC object's *level* property.
    struct LevelData: Codable {
        /// The level data contained within a specific level.
        struct Data: Codable, Comparable {
            static func < (lhs: Compendium.LevelData.Data, rhs: Compendium.LevelData.Data) -> Bool {
                return lhs.level < rhs.level
            }
            
            private var _abilityModifiers: [String]?
            private var _armorProficiencies: [String]?
            private var _conditionImmunities: [String]?
            private var _damageResistances: [String]?
            private var _saves: [String]?
            private var _skills: [String]?
            private var _traits: [String]?
            
            /// A list of challenge modifiers associated with the Data object, if any (only present with Occupation objects).
            var _challengeModifiers: [String]?
            
            /// The level associated with the Data object.
            var level: Int
            
            /// The title associated with the Data object (only present with Occupation objects).
            var title: String?
            
            /// The range of truesight associated with the Data object (only present with Occupation objects).
            var truesight: Int?
            
            /// A list of of modifiers (only present with Occupation objects) to be used when calculating ability scores.
            var abilityModifiers: [Ability.Modifier] {
                return (_abilityModifiers ?? []).compactMap({ Ability.Modifier($0) })
            }
            
            /// A list of armor proficiencies associated with the Data object.
            var armorProficiencies: [Armor] {
                let proficiencyTypes = (_armorProficiencies ?? []).compactMap({ Proficiency.ArmorType(rawValue: $0) })
                let typeArmors = proficiencyTypes.flatMap({ $0.armors })
                return (_armorProficiencies ?? []).compactMap({ Compendium.instance.armors[$0] }) + typeArmors
            }
            
            /// A list of condition immunities associated with the Data object (only present with Occupation objects).
            var conditionImmunities: [Condition] {
                return (_conditionImmunities ?? []).compactMap({ Condition(rawValue: $0) })
            }
            
            /// A list of damage resistances associated with the Data object (only present with Occupation objects).
            var damageResistances: [Action.DamageType] {
                return (_damageResistances ?? []).compactMap({ Action.DamageType(rawValue: $0) })
            }
            
            /// A list of saving throws associated with the Data object (only present with Occupation objects).
            var saves: [SavingThrow] {
                return (_saves ?? []).compactMap({ SavingThrow(rawValue: $0) })
            }
            
            /// A list of skills associated with the Data object (only present with Occupation objects).
            var skills: [Skill] {
                return (_skills ?? []).compactMap({ Skill(rawValue: $0) })
            }
            
            /// A list of damage resistances associated with the Data object.
            var traits: [Trait] {
                return (_traits ?? []).compactMap({ Compendium.instance.traits[$0] })
            }
        }
        
        private var first: Data?
        private var second: Data?
        private var third: Data?
        private var fourth: Data?
        private var fifth: Data?
        private var sixth: Data?
        private var seventh: Data?
        private var eighth: Data?
        private var ninth: Data?
        private var tenth: Data?
        private var eleventh: Data?
        private var twelfth: Data?
        private var thirteenth: Data?
        private var fourteenth: Data?
        private var fifteenth: Data?
        private var sixteenth: Data?
        private var seventeenth: Data?
        private var eighteenth: Data?
        private var nineteenth: Data?
        private var twentieth: Data?
        
        /// A list of all Data objects contained within the LevelData object.
        private var all: [Data?] {
            return [first, second, third, fourth, fifth,
                    sixth, seventh, eighth, ninth, tenth,
                    eleventh, twelfth, thirteenth, fourteenth, fifteenth,
                    sixteenth, seventeenth, eighteenth, nineteenth, twentieth]
        }
        
        /// A list of only existing Data objects contained within the LevelData object.
        private var existing: [Data] {
            return all.compactMap({ $0 })
        }
        
        subscript(_ level: Int) -> Data? {
            return data(at: level)
        }
        
        /// Finds the Data object within the LevelData object that matches the given level or the first existing Data object of a lesser level.
        /// - Parameter level: The level to begin searching from.
        private func data(at level: Int) -> Data? {
            let data = existing.first(where: { $0.level == level })
            if let data = data {
                return data
            } else {
                if level - 1 != 0 {
                    return self.data(at: level - 1)
                } else {
                    return nil
                }
            }
        }
    }
    
    static let instance = Compendium()
    
    /// The actions contained within the user's compendium.
    var actions = [Action]()
    
    /// The armors contained within the user's compendium.
    var armors = [Armor]()
    
    /// The occupations contained within the user's compendium.
    var occupations = [Occupation]()
    
    /// The races contained within the user's compendium.
    var races = [Race]()
    
    /// The subraces contained within the user's compendium.
    var subraces = [Race.Subrace]()
    
    /// The traits contained within the user's compendium.
    var traits = [Trait]()
    
    /// The weapons contained within the user's compendium.
    var weapons = [Action]()
    
    func encode(to encoder: Encoder) throws {  }
}

extension Array where Element == Compendium.ChallengeModifier {
    /// Calculates an appropriate modifier starting with a designated base.
    /// - Parameter base: The integer to start calculation from.
    func compute(with base: Int) -> Int {
        let equalsModifiers = self.filter({ $0.operation == .equals })
        if equalsModifiers.count > 0 {
            let modifiers = equalsModifiers.map({ $0.modifier })
            return modifiers.greatest()
        } else {
            var baseValue = base
            for modifier in self {
                switch modifier {
                    case .armorClass(let operation, let modifier), .attackBonus(let operation, let modifier), .damagePerRound(let operation, let modifier), .hitPoints(let operation, let modifier):
                    switch operation {
                    case .add: baseValue += modifier
                    case .divide: baseValue /= modifier
                    case .equals: break
                    case .multiply: baseValue *= modifier
                    case .subtract: baseValue -= modifier
                    }
                }
            }
            return baseValue
        }
    }
}
