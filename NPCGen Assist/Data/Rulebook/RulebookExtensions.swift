//
//  RulebookArmor.swift
//  NPCGen Assist
//
//  Created by Michael Craun on 7/22/22.
//

import Foundation
import Rulebook

extension Rulebook.Action {
    init(action: Action) {
        self.init()
        self.areaOfEffect = Rulebook.AreaOfEffect(area: action.areaOfEffect?.area, type: action.areaOfEffect?.type)
        self.damageDie = action._damageDie
        self.damageType = nil
        self.description = action._description
        self.identifier = .autoID()
        self.name = action.name
        self.range = Rulebook.Range(short: action.range?.short, long: action.range?.long)
        self.reach = action.reach
        self.save = Rulebook.SavingThrow(rawValue: action.save?.rawValue ?? "")
        self.type = action._weaponType
        self.versatileDie = action.damageDie?.next().title
    }
}

extension Rulebook.Armor {
    init(armor: Armor) {
        self.init()
        self.baseAC = armor.baseAC
        self.identifier = .autoID()
        self.name = armor.name
        self.type = armor._type
    }
}

extension Rulebook.Occupation {
    init(occupation: Occupation) {
        self.init()
        self.abilityModifiers = nil
        self.actions = nil
        self.challenge = Rulebook.Challengeable(
            challengeModifiers: nil,
            highChallenge: occupation.highChallenge,
            lowChallenge: occupation.lowChallenge)
        self.conditionImmunities = nil
        self.damageImmunities = nil
        self.damageResistances = nil
        self.data = Rulebook.LevelData(data: occupation.data)
        self.identifier = .autoID()
        self.filter = Rulebook.Filterable(
            identifier: nil,
            title: occupation.filterTitle,
            description: occupation.filterDescription)
        self.proficiencies = Rulebook.Proficiencies(
            armors: occupation._armorProficiencies,
            weapons: occupation._weaponProficiencies)
        self.specialFeatures = nil
        self.speeds = nil
    }
    
    mutating func reassociateProficiencies(
        with armors: [Rulebook.Armor],
        weapons: [Rulebook.Action]) {
            var newArmors: [String] = []
            var newWeapons: [String] = []
            
            for armor in self.proficiencies?.armors ?? [] {
                
            }
            
            for weapon in self.proficiencies?.weapons ?? [] {
                
            }
        }
}

extension Rulebook.Race {
    init(race: Race) {
        self.init()
        self.abilityModifiers = race._abilityModifiers
        self.actions = nil
        self.challenge = Rulebook.Challengeable(
            challengeModifiers: nil,
            highChallenge: race.highChallenge,
            lowChallenge: race.lowChallenge)
        self.data = Rulebook.LevelData(data: race.data)
        self.filter = Rulebook.Filterable(
            identifier: nil,
            title: race.filterTitle,
            description: race.filterDescription)
        self.name = race.name
        self.names = Rulebook.Nameable(
            male: race.maleNames,
            female: race.femaleNames,
            family: race.familyNames)
        self.proficiencies = Rulebook.Proficiencies(
            languages: race._languages?.compactMap({ Rulebook.Language(rawValue: $0) }),
            skills: race._skills?.compactMap({ Rulebook.Skill(rawValue: $0) }),
            weapons: race._weaponProficiencies)
        self.resistances = Rulebook.Resistances(
            conditions: nil,
            damageImm: nil,
            damageRes: race._damageResistances)
        self.senses = Rulebook.Vision(darkvision: race.darkvision)
        self.size = race._size
        self.speeds = Rulebook.Speed(land: race.speed)
        self.specialFeatures = race.specialFeatures.map({ old in
            switch old {
            case .abilityPlusOne:
                return Rulebook.SpecialFeature(
                    name: "Ability Plus One",
                    appliesTo: "abilityScores",
                    formula: "+1")
            case .dwarvenToughness:
                return Rulebook.SpecialFeature(
                    name: "Dwarven Toughness",
                    appliesTo: "hitPoints",
                    formula: "+1*level")
            case .extraLanguage:
                return Rulebook.SpecialFeature(
                    name: "Extra Language",
                    appliesTo: "languages",
                    formula: "+1")
            case .skillVersatility:
                return Rulebook.SpecialFeature(
                    name: "Skill Versatility",
                    appliesTo: "skills",
                    formula: "+1")
            }
        })
        #warning("These will have different identifiers once uploaded to Firestore!!")
        self.subraces = race._subraces
    }
}

extension Rulebook.Subrace {
    init(subrace: Race.Subrace) {
        self.init()
        self.abilityModifiers = subrace._abilityModifiers
        self.actions = subrace._actions
        self.challenge = Rulebook.Challengeable(
            challengeModifiers: subrace._challengeModifiers,
            highChallenge: nil,
            lowChallenge: nil)
        self.data = Rulebook.LevelData(data: subrace.data)
        self.name = subrace.name
        self.names = Rulebook.Nameable(
            male: subrace.maleNames,
            female: subrace.femaleNames,
            family: subrace.familyNames)
        self.proficiencies = Rulebook.Proficiencies(
            armors: subrace._armorProficiencies,
            weapons: subrace._weaponProficiencies)
        #warning("This will have a different identifier once uploaded to Firestore!!")
        self.race = subrace.race
        self.resistances = Rulebook.Resistances(
            conditions: nil,
            damageImm: nil,
            damageRes: subrace._damageResistances)
        self.senses = Rulebook.Vision(darkvision: subrace.darkvision)
        self.specialFeatures = subrace.specialFeatures.map({ old in
            switch old {
            case .abilityPlusOne:
                return Rulebook.SpecialFeature(
                    name: "Ability Plus One",
                    appliesTo: "abilityScores",
                    formula: "+1")
            case .dwarvenToughness:
                return Rulebook.SpecialFeature(
                    name: "Dwarven Toughness",
                    appliesTo: "hitPoints",
                    formula: "+1*level")
            case .extraLanguage:
                return Rulebook.SpecialFeature(
                    name: "Extra Language",
                    appliesTo: "languages",
                    formula: "+1")
            case .skillVersatility:
                return Rulebook.SpecialFeature(
                    name: "Skill Versatility",
                    appliesTo: "skills",
                    formula: "+1")
            }
        })
        self.speeds = Rulebook.Speed(land: subrace.speed)
    }
}

extension Rulebook.Trait {
    init(trait: Trait) {
        self.init()
        self.description = trait._description
        self.identifier = .autoID()
        self.title = trait.title
    }
}

extension Rulebook.LevelData {
    init(data: Compendium.LevelData?) {
        self.init()
        self.first = Rulebook.LevelData.Level(data: data?._first)
        self.second = Rulebook.LevelData.Level(data: data?._second)
        self.third = Rulebook.LevelData.Level(data: data?._third)
        self.fourth = Rulebook.LevelData.Level(data: data?._fourth)
        self.fifth = Rulebook.LevelData.Level(data: data?._fifth)
        self.sixth = Rulebook.LevelData.Level(data: data?._sixth)
        self.seventh = Rulebook.LevelData.Level(data: data?._seventh)
        self.eighth = Rulebook.LevelData.Level(data: data?._eighth)
        self.ninth = Rulebook.LevelData.Level(data: data?._ninth)
        self.tenth = Rulebook.LevelData.Level(data: data?._tenth)
        self.eleventh = Rulebook.LevelData.Level(data: data?._eleventh)
        self.twelfth = Rulebook.LevelData.Level(data: data?._twelfth)
        self.thirteenth = Rulebook.LevelData.Level(data: data?._thirteenth)
        self.fourteenth = Rulebook.LevelData.Level(data: data?._fourteenth)
        self.fifteenth = Rulebook.LevelData.Level(data: data?._fifteenth)
        self.sixteenth = Rulebook.LevelData.Level(data: data?._sixteenth)
        self.seventeenth = Rulebook.LevelData.Level(data: data?._seventeenth)
        self.eighteenth = Rulebook.LevelData.Level(data: data?._eighteenth)
        self.nineteenth = Rulebook.LevelData.Level(data: data?._nineteenth)
        self.twentieth = Rulebook.LevelData.Level(data: data?._twentieth)
    }
}

extension Rulebook.LevelData.Level {
    init(data: Compendium.LevelData.Data?) {
        self.init()
        self.abilityModifiers = data?._abilityModifiers
        self.challenge = Rulebook.Challengeable(
            challengeModifiers: data?._challengeModifiers,
            highChallenge: nil,
            lowChallenge: nil)
        self.languages = nil
        self.level = data?.level
        self.proficiencies = Rulebook.Proficiencies(
            armors: data?._armorProficiencies,
            saves: data?._saves,
            skills: data?._skills?.compactMap({ Rulebook.Skill(rawValue: $0) }))
        self.resistances = Rulebook.Resistances(
            conditions: data?._conditionImmunities,
            damageImm: nil,
            damageRes: data?._damageResistances)
        self.senses = Rulebook.Vision(truesight: data?.truesight)
        self.speeds = nil
        self.title = data?.title
        #warning("These will have different identifiers once uploaded to Firestore!!")
        self.traits = data?._traits
    }
}
