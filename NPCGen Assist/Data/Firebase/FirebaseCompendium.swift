//
//  FirebaseCompendium.swift
//  NPCGen5e
//
//  Created by Michael Craun on 2/1/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import Foundation
import FireStorage

fileprivate extension FirebaseManager.Key {
    enum Core: Int, FirebaseKey {
        case actions
        case armors
        case occupations
        case races
        case subraces
        case traits
        case weapons
        
        static let locks: [Bool] = [false, false, false, false, false, false, false]
        
        var key: String {
            switch self {
            case .actions: return "actions"
            case .armors: return "armors"
            case .occupations: return "occupations"
            case .races: return "races"
            case .subraces: return "subraces"
            case .traits: return "traits"
            case .weapons: return "weapons"
            }
        }
    }
}

class FirebaseCompendium: FirebaseManager {
    typealias ChallengeCompletion = () -> Void
    
    /// The custom completion of the FirebaseCompendium FirebaseManager object.
    /// - Parameters:
    ///  - success: A boolean to indicate whether or not the operation was successful.
    ///  - error: Any error encountered while completing the operation.
    typealias CompendiumCompletion = (_ success: Bool, _ error: Error?) -> Void
    
    /// Initializes the user's personal compendium, throwing an error if any are encountered.
    /// - Parameter completion: The completion handler designating if the operation failed or succeeded.
    func initializeCoreCompendium(completion: @escaping CompendiumCompletion) {
        let dispatch = DispatchGroup()
        
        var encounteredError: Error? {
            didSet {
                guard let error = encounteredError else { return }
                completion(false, error)
                return
            }
        }
        
        dispatch.enter()
        fetchActions { (actions, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.actions = actions
        }
        
        dispatch.enter()
        fetchArmor { (armors, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.armors = armors
        }
        
        dispatch.enter()
        fetchOccupations { (occupations, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.occupations = occupations
        }
        
        dispatch.enter()
        fetchRaces { (races, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.races = races
        }
        
        dispatch.enter()
        fetchSubraces { (subraces, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.subraces = subraces
        }
        
        dispatch.enter()
        fetchTraits { (traits, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.traits = traits
        }
        
        dispatch.enter()
        fetchWeapons { (weapons, error) in
            dispatch.leave()
            encounteredError = error
            Compendium.instance.weapons = weapons
        }
        
        dispatch.notify(queue: .main) {
            completion(encounteredError == nil, encounteredError)
        }
    }
    
    private func fetchActions(completion: @escaping ([Action], Error?) -> Void) {
        Store.database.actions.getAll(ofType: Action.self) { actions, error in
            if let actions = actions, error == nil {
                completion(actions, nil)
            }
        }
    }
    
    private func fetchArmor(completion: @escaping ([Armor], Error?) -> Void) {
        Store.database.armors.getAll(ofType: Armor.self) { armors, error in
            if let armors = armors, error == nil {
                completion(armors, nil)
            }
        }
    }
    
    private func fetchOccupations(completion: @escaping ([Occupation], Error?) -> Void) {
        Store.database.occupations.getAll(ofType: Occupation.self) { occupations, error in
            if let occupations = occupations, error == nil {
                completion(occupations, nil)
            }
        }
    }
    
    private func fetchRaces(completion: @escaping ([Race], Error?) -> Void) {
        Store.database.races.getAll(ofType: Race.self) { races, error in
            if let races = races, error == nil {
                completion(races, nil)
            }
        }
    }
    
    private func fetchSubraces(completion: @escaping ([Race.Subrace], Error?) -> Void) {
        Store.database.subraces.getAll(ofType: Race.Subrace.self) { subraces, error in
            if let subraces = subraces, error == nil {
                completion(subraces, nil)
            }
        }
    }
    
    private func fetchTraits(completion: @escaping ([Trait], Error?) -> Void) {
        Store.database.traits.getAll(ofType: Trait.self) { traits, error in
            if let traits = traits, error == nil {
                completion(traits, nil)
            }
        }
    }
    
    private func fetchWeapons(completion: @escaping ([Action], Error?) -> Void) {
        Store.database.weapons.getAll(ofType: Action.self) { weapons, error in
            if let weapons = weapons, error == nil {
                completion(weapons, nil)
            }
        }
    }
}

// MARK: - NPCGen Assist specific functionality
extension FirebaseCompendium {
    typealias CoreDatabaseUploadCompletion = (Error?, Error?) -> Void
    
    private func put(data: [String : Any], on child: String, withUID uid: String, completion: @escaping CoreDatabaseUploadCompletion) {
//        let ref = ref_coreDatabase.child(child).child(uid)
//        ref.updateChildValues(data, withCompletionBlock: completion)
    }
    
    func updateChallengeRatings(completion: @escaping ChallengeCompletion) {
        // 1. Iterate through all possible combinations of Occupation, Race, and levels
        let occupations = Compendium.instance.occupations
        let races = Compendium.instance.races
        
        let dispatch = DispatchGroup()
        for occupation in occupations {
            for race in races {
                for level in 1...20 {
                    // 2. Create NPC from these values
                    let npc = NPC(level: level, occupation: occupation, race: race)
                    // 3. Iterate through all possible Armor and Action for this NPC
                    let armorProfs = npc.armorProficiencies
                    let meleeWeaponProfs = npc.weaponProficiencies.meleeWeapons
                    let rangedWeaponProfs = npc.weaponProficiencies.rangedWeapons
                    for armorProf in armorProfs {
                        for meleeWeaponProf in meleeWeaponProfs {
                            for rangedWeaponProf in rangedWeaponProfs {
                                npc.set(armor: armorProf)
                                npc.set(melee: meleeWeaponProf)
                                npc.set(ranged: rangedWeaponProf)
                                // 4. Calculate an appropriate CR for each iteration
                                // 5. Update occupation and race with low CR and high CR if a lower/higher CR is found
                                dispatch.enter()
                                occupation.update(challenge: npc.challenge) {
                                    dispatch.leave()
                                }
                                
                                dispatch.enter()
                                race.update(challenge: npc.challenge) {
                                    dispatch.leave()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        dispatch.notify(queue: .main) {
            completion()
        }
    }
    
    func fetchOccupation(uid: String, completion: @escaping ([String : Any]?) -> Void) {
//        ref_coreDatabase.child("occupation").child(uid).getData { error, snap in
//            if let error = error {
//                print(error)
//                return completion(nil)
//            }
//            
//            completion(snap.value as? [String : Any])
//        }
    }
    
    func putAction(uid: String, data: [String : Any], completion: @escaping CoreDatabaseUploadCompletion) {
        put(data: data, on: "action", withUID: uid, completion: completion)
    }
    
    func putOccupation(uid: String, data: [String : Any], completion: @escaping CoreDatabaseUploadCompletion) {
        put(data: data, on: "occupation", withUID: uid, completion: completion)
    }
    
    func putTrait(uid: String, data: [String : Any], completion: @escaping CoreDatabaseUploadCompletion) {
        put(data: data, on: "trait", withUID: uid, completion: completion)
    }
    
//    func removeAction
//
//    func removeOccupation
//
//    func removeTrait
}
