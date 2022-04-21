//
//  Exportable.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/15/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

class Exporter {
    typealias ExportableData = Any
    typealias ExporterCompletion = (String?) -> Void
    
    private enum Option: String, CaseIterable {
        case npc = "NPC"
        case text = "Text"
        case xml = "XML"
    }
    
    enum Key: String {
        // MARK: NPC file keys
        case alignment
        case appearance
        case bond
        case challenge
        case flaw
        case gender
        case id
        case image
        case level
        case mannerism
        case melee
        case name
        case occupation
        case race
        case ranged
        case subrace
        case talent
        
        // MARK: XML keys
        case ac
        case cha
        case con
        case conditionImmune
        case cr
        case dex
        case hp
        case immune
        case int
        case languages
        case passive
        case resist
        case save
        case senses
        case size
        case skill
        case speed
        case str
        case trait
        case type
        case vulnerable
        case wis
        
        case shortName
        case weaponActions
    }
    
    private var npc: NPC
    private var parent: UIViewController
    
    /// <#Description#>
    /// - Parameters:
    ///   - npc: <#npc description#>
    ///   - parent: <#parent description#>
    ///   - completion: <#completion description#>
    init(npc: NPC, parent: UIViewController, sourceView: UIView? = nil, completion: @escaping ExporterCompletion) {
        self.npc = npc
        self.parent = parent
        
        showActionSheet(with: sourceView) { (actionSheet, option) in
            actionSheet.dismiss(animated: true, completion: nil)
            switch option {
            case .npc:
                self.exportAsNPCFile { (data, error) in
                    guard let error = error else {
                        self.showExportSheet(with: data, sourceView: sourceView)
                        completion(nil)
                        return
                    }
                    completion(error)
                }
            case .text:
                let text = self.exportAsText()
                self.showExportSheet(with: text, sourceView: sourceView)
                completion(nil)
            case .xml:
                completion(nil)
            case .none:
                completion(nil)
            }
        }
    }
    
    static func serializeForImport(_ dictionary: [String : Any]) -> [Exporter.Key : Any?]? {
        guard let alignment = dictionary[Key.alignment.rawValue] as? String,
            let challenge = dictionary[Key.challenge.rawValue] as? String,
            let gender = dictionary[Key.gender.rawValue] as? Int,
            let meleeIdentifier = dictionary[Key.melee.rawValue] as? String,
            let occupationIdentifier = dictionary[Key.occupation.rawValue] as? String,
            let raceIdentifier = dictionary[Key.race.rawValue] as? String,
            let rangedIdentifier = dictionary[Key.ranged.rawValue] as? String,
            let subraceIdentifier = dictionary[Key.subrace.rawValue] as? String else {
            return nil
        }
        
        let melee: Action? = Compendium.instance.weapons[meleeIdentifier]
        let occupation: Occupation? = Compendium.instance.occupations[occupationIdentifier]
        let race: Race? = Compendium.instance.races[raceIdentifier]
        let ranged: Action? = Compendium.instance.weapons[rangedIdentifier]
        let subrace: Race.Subrace? = Compendium.instance.subraces[subraceIdentifier]
        
        return [
            .alignment : Alignment(rawValue: alignment),
            .appearance : dictionary[Key.appearance.rawValue],
            .bond : dictionary[Key.bond.rawValue],
            .challenge : Challenge(rawValue: challenge),
            .flaw : dictionary[Key.flaw.rawValue],
            .gender : Gender(rawValue: gender),
            .image : dictionary[Key.image.rawValue],
            .level : dictionary[Key.level.rawValue],
            .mannerism : dictionary[Key.mannerism.rawValue],
            .melee : melee,
            .name : dictionary[Key.name.rawValue],
            .occupation : occupation,
            .race : race,
            .ranged : ranged,
            .subrace : subrace,
            .talent : dictionary[Key.talent.rawValue]
        ]
    }
    
    /// <#Description#>
    /// - Parameter completion: <#completion description#>
    private func showActionSheet(with sourceView: UIView?, completion: @escaping (UIAlertController, Option?) -> Void) {
        let actionSheet = UIAlertController(title: nil, message: "Export as...", preferredStyle: .actionSheet)
        actionSheet.popoverPresentationController?.sourceRect = sourceView?.bounds ?? parent.view.bounds
        actionSheet.popoverPresentationController?.sourceView = sourceView ?? parent.view
        
        for option in Option.allCases {
            let action = UIAlertAction(title: option.rawValue, style: .default) { (_) in
                completion(actionSheet, option)
            }
            actionSheet.addAction(action)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            completion(actionSheet, nil)
        }
        actionSheet.addAction(cancel)
        
        parent.present(actionSheet, animated: true, completion: nil)
    }
    
    /// Exports the selected NPC as an NPC file to share with other users of NPCGen5e
    /// - parameter npc: The NPC the user wishes to export
    /// - parameter image: The optional image associated with the selected NPC
    private func exportAsNPCFile(completion: @escaping (ExportableData?, String?) -> Void) {
        
    }
    
    /// Exports the selected NPC as text
    /// - parameter npc: The NPC the user wishes to export
    private func exportAsText() -> ExportableData {
        return """
        NPC from NPCGen5e:
        \(npc.name)
        \(npc.detailsDescription)
        Armor Class \(npc.armorClassDescription)
        Hit Points \(npc.hitPointsDescription)
        Speed \(npc.speedDescription)
        STR: \(npc.abilityScores[Ability.str]!.score.abilityDescription)
        DEX \(npc.abilityScores[Ability.dex]!.score.abilityDescription)
        CON \(npc.abilityScores[Ability.con]!.score.abilityDescription)
        INT \(npc.abilityScores[Ability.int]!.score.abilityDescription)
        WIS \(npc.abilityScores[Ability.wis]!.score.abilityDescription)
        CHA \(npc.abilityScores[Ability.cha]!.score.abilityDescription)
        Saving Throws \(npc.savingThrowDescription)
        Skills \(npc.skillsDescription)
        Damage Resistances \(npc.damageResistanceDescription)
        Damage Immunities \(npc.damageImminitiesDescription)
        Condition Immunities \(npc.conditionImmunitiesDescription)
        Senses \(npc.sensesDescription)
        Languages \(npc.languagesDescription)
        Challenge \(npc.challenge.rating) (\(npc.challenge.xpValue) xp)
        Occupation \(npc.occupationTitle)

        ROLEPLAYING
        Mannerism. \(npc.details.mannerism)

        Talent. \(npc.details.talent)

        Bond. \(npc.details.bond)

        Flaw. \(npc.details.flaw)

        Appearance. \(npc.details.appearance)
        
        TRAITS
        \(npc.traitsDescription)ACTIONS
        \(npc.actionsDescription)
        """
    }
    
    /// <#Description#>
    /// - Parameter data: <#data description#>
    private func showExportSheet(with data: ExportableData?, sourceView: UIView?) {
        guard let data = data else {
            print("Unable to export NPC. Please try again, later...")
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceRect = sourceView?.bounds ?? parent.view.bounds
        activityController.popoverPresentationController?.sourceView = sourceView ?? parent.view
        parent.present(activityController, animated: true, completion: nil)
    }
}
