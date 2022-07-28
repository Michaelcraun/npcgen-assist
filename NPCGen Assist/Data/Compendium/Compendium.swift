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
            
            var _abilityModifiers: [String]?
            var _armorProficiencies: [String]?
            var _conditionImmunities: [String]?
            var _damageResistances: [String]?
            var _saves: [String]?
            var _skills: [String]?
            var _traits: [String]?
            
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
        
        var first: Data?
        var second: Data?
        var third: Data?
        var fourth: Data?
        var fifth: Data?
        var sixth: Data?
        var seventh: Data?
        var eighth: Data?
        var ninth: Data?
        var tenth: Data?
        var eleventh: Data?
        var twelfth: Data?
        var thirteenth: Data?
        var fourteenth: Data?
        var fifteenth: Data?
        var sixteenth: Data?
        var seventeenth: Data?
        var eighteenth: Data?
        var nineteenth: Data?
        var twentieth: Data?
        
        /// A list of all Data objects contained within the LevelData object.
        var all: [Data?] {
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

// MARK: - NPCGen Assist specific functionality
extension Compendium.LevelData {
    var _first: Data? { return first }
    var _second: Data? { return second }
    var _third: Data? { return third }
    var _fourth: Data? { return fourth }
    var _fifth: Data? { return fifth }
    var _sixth: Data? { return sixth }
    var _seventh: Data? { return seventh }
    var _eighth: Data? { return eighth }
    var _ninth: Data? { return ninth }
    var _tenth: Data? { return tenth }
    var _eleventh: Data? { return eleventh }
    var _twelfth: Data? { return twelfth }
    var _thirteenth: Data? { return thirteenth }
    var _fourteenth: Data? { return fourteenth }
    var _fifteenth: Data? { return fifteenth }
    var _sixteenth: Data? { return sixteenth }
    var _seventeenth: Data? { return seventeenth }
    var _eighteenth: Data? { return eighteenth }
    var _nineteenth: Data? { return nineteenth }
    var _twentieth: Data? { return twentieth }
    
    init(data: [Int : Data]) {
        self.first = data[1]
        self.second = data[2]
        self.third = data[3]
        self.fourth = data[4]
        self.fifth = data[5]
        self.sixth = data[6]
        self.seventh = data[7]
        self.eighth = data[8]
        self.ninth = data[9]
        self.tenth = data[10]
        self.eleventh = data[11]
        self.twelfth = data[12]
        self.thirteenth = data[13]
        self.fourteenth = data[14]
        self.fifteenth = data[15]
        self.sixteenth = data[16]
        self.seventeenth = data[17]
        self.eighteenth = data[18]
        self.nineteenth = data[19]
        self.twentieth = data[20]
    }
}

extension Compendium.LevelData.Data {
    init(
        level: Int,
        title: String,
        abilityModifiers: [Ability.Modifier],
        saves: [SavingThrow],
        skills: [Skill],
        
        armors: [String]? = nil,
        challengeModifiers: [String]? = nil,        // Challenge.Modifier
        conditionImmunities: [String]? = nil,
        damageResistances: [String]? = nil,
        traits: [String]? = nil,
        truesight: Int? = nil) {
            self._abilityModifiers = abilityModifiers.map({ "\($0.comparableValue) \($0.modifier.modifier)" })
            self._armorProficiencies = armors
            self._challengeModifiers = challengeModifiers
            self._conditionImmunities = conditionImmunities
            self._damageResistances = damageResistances
            self._saves = saves.map({ $0.comparableValue })
            self._skills = skills.map({ $0.rawValue })
            self._traits = traits
            self.level = level
            self.title = title
            self.truesight = truesight
        }
}
