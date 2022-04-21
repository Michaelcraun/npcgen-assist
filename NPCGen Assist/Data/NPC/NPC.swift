//
//  CompendiumNPC.swift
//  NPCGen5e
//
//  Created by Michael Craun on 9/7/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import UIKit

/// The NPC class of version 4.1, using the new Firebase compendium data models.
class NPC: Codable {
    /// An NPC reduced to it's basic elements.
    struct Raw: Codable {
        var alignment: String?
        var appearance: String?
        var bond: String?
        var challenge: String?
        var flaw: String?
        var gender: Int?
        var id: String?
        var level: Int?
        var mannerism: String?
        var meleeAttack: String?
        var name: String?
        var occupation: String?
        var photo: String?
        var race: String?
        var rangedAttack: String?
        var subrace: String?
        var talent: String?
        var uid: String?
        
        // MARK: - Initializers
        init?(from npc: NPC) {
            guard let uid = FirebaseManager.authorization.user?.id else { return nil }
            self.alignment = npc.alignment.rawValue
            self.appearance = npc.details.appearance
            self.bond = npc.details.bond
            self.challenge = npc.challenge.rawValue
            self.flaw = npc.details.flaw
            self.gender = npc.gender.rawValue
            self.id = npc.id
            self.level = npc.level
            self.mannerism = npc.details.mannerism
            self.meleeAttack = npc.meleeAttack?.identifier
            self.name = npc.name
            self.occupation = npc.occupation.identifier
            self.race = npc.race.identifier
            self.rangedAttack = npc.rangedAttack?.identifier
            self.subrace = npc.subrace?.identifier
            self.talent = npc.details.talent
            self.uid = uid
        }
        
        // MARK: - Utility functions
        func npc() -> NPC? {
            return NPC(from: self)
        }
    }
    
    struct LevelData {
        private var occupation: Compendium.LevelData.Data?
        private var race: Compendium.LevelData.Data?
        private var subrace: Compendium.LevelData.Data?
        
        init(level: Int, occupation: Occupation, race: Race, subrace: Race.Subrace?) {
            self.occupation = occupation.data?[level]
            self.race = race.data?[level]
            self.subrace = subrace?.data?[level]
        }
        
        var abilityModifiers: [Ability.Modifier] {
            return occupation?.abilityModifiers ?? []
        }
        
        var challengeModifiers: [String] {
            return occupation?._challengeModifiers ?? []
        }
        
        var conditionImmunities: [Condition] {
            return occupation?.conditionImmunities ?? []
        }
        
        var damageResistances: [Action.DamageType] {
            return occupation?.damageResistances ?? []
        }
        
        var saves: [SavingThrow] {
            return occupation?.saves ?? []
        }
        
        var skills: [Skill] {
            return occupation?.skills ?? []
        }
        
        var title: String {
            return occupation?.title ?? "ERROR!"
        }
        
        var traits: [Trait] {
            return (occupation?.traits ?? []) + (race?.traits ?? []) + (subrace?.traits ?? [])
        }
        
        var truesight: Int {
            return occupation?.truesight ?? 0
        }
    }
    
    /// The NPC object's randomized alignment.
    private var alignment: Alignment
    
    /// The NPC object's melee attack for determining the NPC object's *actions* property.
    private var meleeAttack: Action?
    
    /// The NPC object's occupation.
    private var occupation: Occupation
    
    /// The identifier of the stored photo on the Firebase database.
    private var photo: String?
    
    /// The NPC object's race.
    private var race: Race
    
    /// The NPC object's ranged attack for determining the NPC object's *actions* property.
    private var rangedAttack: Action?
    
    /// The NPC object's subrace, if it has one (designated by the *race* property at initlalization).
    private var subrace: Race.Subrace?
    
    /// The challenge rating of the generated NPC object.
    var challenge: Challenge = .zero
    
    /// An instance of the Details class that houses the details (mannerism, talent, etc.) of the NPC object.
    var details: Details!
    
    /// The randomized gender of the NPC object.
    var gender: Gender
    
    /// A unique identifier associated with the NPC object.
    var id: String
    
    /// The level of the NPC object used to determine available traits and in calculating bonuses and hit dice.
    var level: Int
    
    /// The NPC object's full name.
    var name: String = ""
    
    // MARK: - Initializers
    /// The default initializer for NPC objects.
    /// - Parameters:
    ///   - level: The desired level of the NPC object (defaults to a randomly selected Int between 1 and 20).
    ///   - occupation: The desired occupation of the NPC object (defaults to a randomly selected Occupation object stored within the Compendium).
    ///   - race: The target race of the NPC object (defaults to a randomly selected Race object stored within the Compendium).
    init(level: Int = Int.random(in: 1...20), occupation: Occupation = Compendium.instance.occupations.randomElement()!, race: Race = Compendium.instance.races.randomElement()!) {
        self.alignment = Alignment.random()
        self.gender = Gender.random()
        self.id = String.random()
        self.level = level
        self.occupation = occupation
        self.race = race
        self.subrace = race.subraces.randomElement()
        
        self.name = computedName
        self.details = Details(npc: self)
        
        self.meleeAttack = weaponProficiencies.meleeWeapons.randomElement()
        self.rangedAttack = weaponProficiencies.rangedWeapons.randomElement()
        self.setChallenge()
    }
    
    /// The optional initializer for converting a raw NPC object into an NPC object.
    /// - If the raw object's *occupation* or *race* cannot be found within the new occupations or races, initialization failse.
    /// - Parameter raw: The NPC.Raw object to convert to an NPC object.
    init?(from raw: NPC.Raw) {
        guard let occupation: Occupation = Compendium.instance.occupations[raw.occupation ?? ""] else { return nil }
        guard let race: Race = Compendium.instance.races[raw.race ?? ""] else { return nil }
        
        self.alignment = Alignment(rawValue: raw.alignment ?? "") ?? .chaoticEvil
        self.challenge = Challenge(rawValue: raw.challenge ?? "") ?? .zero
        self.gender = Gender(rawValue: raw.gender ?? 0) ?? .female
        self.id = raw.id ?? ""
        self.level = raw.level ?? 0
        self.meleeAttack = Compendium.instance.weapons[raw.meleeAttack ?? ""]
        self.name = raw.name ?? ""
        self.occupation = occupation
        self.photo = raw.photo
        self.race = race
        self.rangedAttack = Compendium.instance.weapons[raw.rangedAttack ?? ""]
        self.details = Details(npc: self, appearance: raw.appearance, bond: raw.bond, flaw: raw.flaw, mannerism: raw.mannerism, talent: raw.talent)
    }
    
    // MARK: - Private computed properties
    /// The armor the NPC object currently has equipped, if any.
    private var armor: Armor? {
        return armorProficiencies.randomElement()
    }
    
    /// The armor class of the NPC object, constructed from the *armor* property and the NPC object's dexterity.
    private var armorClass: Int {
        let dexModifier = abilityScores[Ability.dex]!.modifier
        guard let armor = armor else { return 10 + dexModifier }
        return armor.armorClass(with: abilityScores)
    }
    
    /// The NPC object's list of armor proficiencies.
    var armorProficiencies: [Armor] {
        return (subrace?.armorProficiencies ?? []) + occupation.armorProficiencies
    }
    
    /// The NPC object's list of challenge rating modifiers, used in determining the NPC object's overall challenge rating.
    private var challengeModifiers: [Compendium.ChallengeModifier] {
        var _challengeModifiers: [String] {
            return (race._challengeModifiers ?? []) + levelData.challengeModifiers + (subrace?._challengeModifiers ?? [])
        }
        return _challengeModifiers.compactMap({ Compendium.ChallengeModifier($0, level: level, abilityScores: abilityScores) })
    }
    
    /// The full name of the NPC object computed from the NPC object's *race* and *subrace* properties.
    private var computedName: String {
        guard let subrace = subrace else {
            let first = race.firstName(for: gender)
            let surname = race.lastName()
            return surname == nil ? first : "\(first) \(surname!)"
        }
        let first = subrace.firstName(for: gender)
        let surname = subrace.lastName
        return surname == nil ? first : "\(first) \(surname!)"
    }
    
    /// The list of Condition objects that the NPC object has immunity to.
    private var conditionImmunities: [Condition] {
        return levelData.conditionImmunities
    }
    
    /// The list of Action.DamageType objects that the NPC object has immunity to.
    private var damageImmunities: [Action.DamageType] {
        return []
    }
    
    /// The list of Action.DamageType objects that the NPC object has resistance to.
    private var damageResistances: [Action.DamageType] {
        return (race.damageResistances + levelData.damageResistances + (subrace?.damageResistances ?? [])).removingDuplicates()
    }
    
    /// The range of the NPC object's darkvision.
    private var darkvision: Int {
        return subrace == nil ? race.darkvision : race.darkvision + subrace!.darkvision
    }
    
    /// The armor class of the NPC object used when calculating the *challenge* property.
    private var effectiveArmorClass: Int {
        let modifiers = challengeModifiers.filter({ $0.type == .armorClass })
        return modifiers.compute(with: armorClass)
    }
    
    /// The attack bonus of the NPC object used when calculating the *challenge* property.
    private var effectiveAttackBonus: Int {
        var bonus = 0
        let modifiers = challengeModifiers.filter({ $0.type == .attackBonus })
        for weapon in actions {
            guard let weaponType = weapon.weaponType else { continue }
            switch weaponType {
            case .martial(let type), .simple(let type):
                switch type {
                case .melee: bonus = modifiers.compute(with: meleeAttackModifier) > bonus ? modifiers.compute(with: meleeAttackModifier) : bonus
                case .ranged: bonus = modifiers.compute(with: rangedAttackModifier) > bonus ? modifiers.compute(with: rangedAttackModifier) : bonus
                case .thrown: bonus = modifiers.compute(with: meleeAttackModifier) > bonus ? modifiers.compute(with: meleeAttackModifier) : bonus
                }
            case .natural: bonus = modifiers.compute(with: meleeAttackModifier) > bonus ? modifiers.compute(with: meleeAttackModifier) : bonus
            case .none:bonus = modifiers.compute(with: meleeAttackModifier) > bonus ? modifiers.compute(with: meleeAttackModifier) : bonus
            }
        }
        return bonus
    }
    
    /// The amount of damage the NPC object can deal per round used when calculating the *challenge* property.
    private var effectiveDamagePerRound: Int {
        var damage = 0
        let modifiers = challengeModifiers.filter({ $0.type == .damagePerRound })
        for weapon in actions {
            guard let weaponType = weapon.weaponType else { continue }
            switch weaponType {
            case .martial(let type), .simple(let type):
                switch type {
                case .melee: damage = modifiers.compute(with: meleeDamageBonus) > damage ? modifiers.compute(with: meleeDamageBonus) : damage
                case .ranged: damage = modifiers.compute(with: rangedDamageBonus) > damage ? modifiers.compute(with: rangedDamageBonus) : damage
                case .thrown: damage = modifiers.compute(with: meleeDamageBonus) > damage ? modifiers.compute(with: meleeDamageBonus) : damage
                }
            case .natural: damage = modifiers.compute(with: meleeDamageBonus) > damage ? modifiers.compute(with: meleeDamageBonus) : damage
            case .none: damage = modifiers.compute(with: meleeDamageBonus) > damage ? modifiers.compute(with: meleeDamageBonus) : damage
            }
        }
        return damage
    }
    
    /// The hit points value of the NPC used when calculating the *challenge* property.
    private var effectiveHitPoints: Int {
        let modifiers = challengeModifiers.filter({ $0.type == .hitPoints })
        return modifiers.compute(with: hitPoints)
    }
    
    /// A boolean value indicating if the NPC object has a shiled.
    private var hasShield: Bool {
        return occupation.armorProficiencies.shields.count > 0 || (subrace?.armorProficiencies.shields.count ?? 0) > 0
    }
    
    /// The bonus to the NPC object's hit points used when calculating the *hitPoints* property and when displaying the NPC object's hit points.
    private var hitPointBonus: Int {
        let modifier = abilityScores[Ability.con]!.modifier
        let bonus = level * modifier
        return (subrace?.specialFeatures ?? []).contains(.dwarvenToughness) ? bonus + level : bonus
    }
    
    /// The total hit point value of the NPC object.
    private var hitPoints: Int {
        return Int(Double(level) * 4.5) + hitPointBonus
    }
    
    /// The list of Language objects that the NPC object can speak, read, and write.
    private var languages: [Language] {
        var languages = race.languages
        languages += race.specialFeatures.contains(.extraLanguage) ? [Language.random(ignoring: languages)] : []
        languages += (subrace?.specialFeatures ?? []).contains(.extraLanguage) ? [Language.random(ignoring: languages)] : []
        return languages
    }
    
    private var levelData: LevelData {
        return LevelData(level: level, occupation: occupation, race: race, subrace: subrace)
    }
    
    /// The NPC object's passive perception score.
    private var passivePerception: Int {
        let wisModifier = abilityScores[Ability.wis]!.modifier
        return skills.contains(.perception) ? 10 + wisModifier + proficiency : 10 + wisModifier
    }
    
    /// The NPC object's proficiency used when calculating skill bonuses and attack modifiers.
    private var proficiency: Int {
        return challenge.proficiency
    }
    
    /// The list of saving throws the NPC object is proficient in.
    private var savingThrows: [SavingThrow] {
        return levelData.saves
    }
    
    var shortDescription: String {
        guard let subrace = subrace, subrace.name != "" else {
            return "\(level.level) humanoid (\(race.name)) \(occupation.filterTitle), \(gender.descriptor)"
        }
        return "\(level.level) humanoid (\(subrace.name) \(race.name)) \(occupation.filterTitle), \(gender.descriptor)"
    }
    
    /// The list of Skill objects the NPC object is proficient in.
    private var skills: [Skill] {
        var skills = (levelData.skills + race.skills).removingDuplicates()
        if race.specialFeatures.contains(.skillVersatility) {
            skills.append(Skill.random(ignoring: skills))
            skills.append(Skill.random(ignoring: skills))
        }
        return skills.sorted()
    }
    
    /// The land speed of the NPC object.
    private var speed: Int {
        return 30 + race.speed + (subrace?.speed ?? 0)
    }
    
    /// The range of the NPC object's truesight.
    private var truesight: Int {
        return levelData.truesight
    }
    
    /// The list of weapons that the NPC object is proficient in.
    var weaponProficiencies: [Action] {
        return race.weaponProficiencies + occupation.weaponProficiencies + (subrace?.weaponProficiencies ?? [])
    }
    
    // MARK: - Computed properties
    /// The list of ability scores of the NPC object.
    var abilityScores: [Ability.Score] {
        var scores: [Ability.Score] = [.str(score: 10), .dex(score: 10), .con(score: 10), .con(score: 10), .int(score: 10), .wis(score: 10), .cha(score: 10)]
        scores.adding(levelData.abilityModifiers)
        scores.adding(race.abilityModifiers)
        scores.adding(subrace?.abilityModifiers ?? [])
        return scores
    }
    
    /// The list of actions available to the NPC object.
    var actions: [Action] {
        var actions = subrace?.actions ?? []
        // TODO: Need to include shield bash, if necessary
        if hasShield { actions.append(Action()) }
        if let meleeAttack = meleeAttack { actions.append(meleeAttack) }
        if let rangedAttack = rangedAttack { actions.append(rangedAttack) }
        return actions
    }
    
    /// A tetual representation of the *actions* property.
    /// - Used when exporting the NPC object.
    var actionsDescription: String {
        var description = ""
        actions.forEach({
            if let _description = $0.description(for: self)?.replacingPlaceholders(with: self) {
                description += "\($0.name). \(_description) \n\n"
            }
        })
        return description
    }
    
    /// A tetual representation of the NPC object's *armor* and *armorClass* properties.
    var armorClassDescription: String {
        guard let armor = armor else { return "\(armorClass)" }
        return hasShield ? "\(armorClass) ((\(armor.name), shield)" :  "\(armorClass) (\(armor.name))"
    }
    
    /// A tetual representation of the NPC object's *challenge* property.
    var challengeDescription: String {
        return "\(challenge.rating) (\(challenge.xpValue) xp)"
    }
    
    /// A tetual representation of the NPC object's *conditionImmunities* property.
    var conditionImmunitiesDescription: String {
        guard conditionImmunities.count > 0 else { return "none" }
        return conditionImmunities.map({ "\($0.rawValue), " }).joined().removingLast(3)
    }
    
    /// A tetual representation of the NPC object's *damageImmunities* property.
    var damageImminitiesDescription: String {
        guard damageImmunities.count > 0 else { return "none" }
        return damageImmunities.map({ "\($0.rawValue), " }).joined().removingLast(3)
    }
    
    /// A tetual representation of the NPC object's *damageResistances* property.
    var damageResistanceDescription: String {
        guard damageResistances.count > 0 else { return "none" }
        return damageResistances.map({ "\($0.rawValue), " }).joined().removingLast(3)
    }
    
    /// A tetual representation of the NPC object used to display the NPC object's *size*, *race*, *subrace*, *gender*, and *alignment* properties.
    var detailsDescription: String {
        guard let subrace = subrace, subrace.name != "" else {
            return "\(race.size.rawValue.capitalized) humanoid (\(race.name)), \(gender.descriptor), \(alignment.descriptor)"
        }
        return "\(race.size.rawValue.capitalized) humanoid (\(subrace.name) \(race.name)), \(gender.descriptor), \(alignment.descriptor)"
    }
    
    /// A dictionary representing the basic properties of the NPC object used to export the NPC object.
    var dictionary: [String : Any?] {
        return [
            // MARK: NPC file elements
            Exporter.Key.alignment.rawValue : alignment.rawValue,
            Exporter.Key.appearance.rawValue : details.appearance,
            Exporter.Key.bond.rawValue : details.bond,
            Exporter.Key.challenge.rawValue: challenge.rawValue,
            Exporter.Key.flaw.rawValue : details.flaw,
            Exporter.Key.gender.rawValue : gender.rawValue,
            Exporter.Key.image.rawValue : photo,
            Exporter.Key.level.rawValue : level,
            Exporter.Key.melee.rawValue : meleeAttack?.identifier,
            Exporter.Key.mannerism.rawValue : details.mannerism,
            Exporter.Key.name.rawValue : name,
            Exporter.Key.occupation.rawValue : occupation.identifier,
            Exporter.Key.race.rawValue : race.identifier,
            Exporter.Key.ranged.rawValue : rangedAttack?.identifier,
            Exporter.Key.subrace.rawValue : subrace?.identifier,
            Exporter.Key.talent.rawValue : details.talent,
            
            "xml" : [
                Exporter.Key.ac.rawValue : armorClassDescription,
                Exporter.Key.cha.rawValue : abilityScores[Ability.cha]!.score,
                Exporter.Key.con.rawValue : abilityScores[Ability.con]!.score,
                Exporter.Key.conditionImmune.rawValue : conditionImmunitiesDescription,
                Exporter.Key.cr.rawValue : challenge.rating,
                Exporter.Key.dex.rawValue : abilityScores[Ability.dex]!.score,
                Exporter.Key.hp.rawValue : hitPointsDescription,
                Exporter.Key.immune.rawValue : damageImminitiesDescription,
                Exporter.Key.int.rawValue : abilityScores[Ability.int]!.score,
                Exporter.Key.languages.rawValue : languagesDescription,
                Exporter.Key.name.rawValue : name,
                Exporter.Key.passive.rawValue : passivePerception,
                Exporter.Key.resist.rawValue : damageResistanceDescription,
                Exporter.Key.save.rawValue : savingThrowDescription,
                Exporter.Key.senses.rawValue : sensesDescription,
                Exporter.Key.size.rawValue : race.size.shortHand,
                Exporter.Key.skill.rawValue : skillsDescription,
                Exporter.Key.speed.rawValue : speedDescription,
                Exporter.Key.str.rawValue : abilityScores[Ability.str]!.score,
                Exporter.Key.type.rawValue : "humanoid (\(race.name))",
                Exporter.Key.vulnerable.rawValue : "",
                Exporter.Key.wis.rawValue : abilityScores[Ability.wis]!.score
            ]
        ]
    }
    
    /// A tetual representation of the NPC object's *hitPoints* property.
    var hitPointsDescription: String {
        if hitPointBonus == 0 {
            return "\(hitPoints) (\(level)d8)"
        } else if hitPointBonus < 0 {
            return "\(hitPoints) (\(level)d8 - \(hitPointBonus * -1))"
        } else {
            return "\(hitPoints) (\(level)d8 + \(hitPointBonus))"
        }
    }
    
    /// A textual representation of the NPC object's *languages* property.
    var languagesDescription: String {
        guard languages.count > 0 else { return "none" }
        return languages.map({ "\($0.description()), " }).joined().removingLast(3)
    }
    
    /// The ability used to determine the effectiveness of the NPC object's melee attacks.
    private var meleeAttackAbility: Ability {
        if abilityScores[Ability.str]!.modifier >= abilityScores[Ability.dex]!.modifier {
            return .str
        } else {
            return .dex
        }
    }
    
    /// The modifier used to determine the effectiveness of the NPC object's melee attacks.
    var meleeAttackModifier: Int {
        return abilityScores[meleeAttackAbility]!.modifier + proficiency
    }
    
    /// The modifier used to determine how much damage the NPC object's attacks will do.
    var meleeDamageBonus: Int {
        return abilityScores[meleeAttackAbility]!.modifier
    }
    
    /// A textual representation of the NPC object's title.
    var occupationTitle: String {
        return levelData.title
    }
    
    /// The modifier used to determine the effectiveness of the NPC object's ranged attacks.
    var rangedAttackModifier: Int {
        return abilityScores[Ability.dex]!.modifier + proficiency
    }
    
    /// The modifier used to determine how much damage the NPC object's attacks will do.
    var rangedDamageBonus: Int {
        return abilityScores[Ability.dex]!.modifier
    }
    
    /// A textual representation of the NPC object's *savingThrows* property.
    var savingThrowDescription: String {
        guard savingThrows.count > 0 else { return "none" }
        return savingThrows.map({ "\($0.description(with: abilityScores, and: proficiency)), " }).joined().removingLast(3)
    }
    
    /// A textual representation of the NPC object's *truesight*, *darkvision*, and *passivePerception* properties.
    var sensesDescription: String {
        var senses = ""
        if truesight > 0 { senses = "truesight \(truesight) ft., " }
        if darkvision > 0 { senses += "darkvision \(darkvision) ft., " }
        senses += "passive Perception \(passivePerception)"
        return senses
    }
    
    /// A textual representation of the NPC object's first name.
    var shortName: String {
        return name.components(separatedBy: " ").first ?? "ERROR!"
    }
    
    /// A textual representation of the NPC object's *skills* property.
    var skillsDescription: String {
        guard skills.count > 0 else { return "none" }
        return skills.map({ "\($0.description(with: abilityScores, and: proficiency)), " }).joined().removingLast(3)
    }
    
    /// A textual representation of the NPC object's *speed* property.
    var speedDescription: String {
        return "\(speed) ft."
    }
    
    /// The list of Trait objects available to the NPC object.
    var traits: [Trait] {
        return levelData.traits.forNPC(self)
    }
    
    /// A textual representation of the NPC object's *traits* object.
    var traitsDescription: String {
        var description = ""
        traits.forEach({ description += "\($0.title). \($0._description) \n\n" })
        return description
    }
    
    // MARK: - Utility functions
    /// Converts the NPC object into an NPC.Raw object.
    /// - Returns: An instance of NPC.Raw representing the NPC object.
    func asRawData() -> Raw? {
        return Raw(from: self)
    }
    
    /// Increases the number of dice in a Die object until apporopriate for the NPC object's *level* property.
    /// - Parameter die: The Die object to increase.
    /// - Returns: A Die object appropriate for the NPC object's level.
    func progressiveDamageDice(using die: Die) -> Die {
        var newDie = die
        if level > 5 {
            for _ in 0..<((level) / 5) {
                newDie.increase()
            }
        }
        return newDie
    }
    
    /// A textual representation of an NPC object's spellcasting ability.
    /// - Parameter ability: The Ability to construct the representation using.
    func spellDescription(_ ability: Ability) -> String {
        let saveDC = saveDCValue(ability)
        let toHit = toHitValue(ability)
        return "(spell save DC \(saveDC), \(toHit.modifier) to hit with spell attacks)"
    }
    
    /// The save DC of an NPC object's spellcating ability.
    /// - Parameter ability: The Ability to construct the save DC using.
    func saveDCValue(_ ability: Ability) -> Int {
        let modifier = abilityScores[ability]!.modifier
        return 8 + modifier + proficiency
    }
    
    /// The to hit value of the NPC object's actions.
    /// - Parameter ability: The Ability to construct the to hit value using.
    func toHitValue(_ ability: Ability) -> Int {
        let modifier = abilityScores[ability]!.modifier
        return modifier + proficiency
    }
    
    /// Calculates and sets the NPC object's *challenge* property.
    private func setChallenge() {
        let challenge = Challenge.calculate(hitPoints: effectiveHitPoints, armorClass: effectiveArmorClass, attackBonus: effectiveAttackBonus, damagePerRound: effectiveDamagePerRound)
        self.challenge = challenge
    }
}

extension NPC {
    func set(armor: Armor) {
        
    }
    
    func set(melee weapon: Action) {
        self.meleeAttack = weapon
    }
    
    func set(ranged weapon: Action) {
        self.rangedAttack = weapon
    }
}

extension Array where Element == NPC {
    /// Sorts a list fo NPC objects accoding to their *name* properties.
    func sorted() -> [NPC] {
        return self.sorted { (npc1, npc2) -> Bool in
            return npc1.name < npc2.name
        }
    }
}

extension Array where Element == NPC? {
    subscript(_ raw: NPC.Raw) -> Int {
        for (index, npc) in self.enumerated() {
            if npc?.id == raw.id {
                return index
            }
        }
        fatalError("\(self.debugDescription) does not contain npc with id \(String(describing: raw.id))")
    }
}
