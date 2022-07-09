//
//  FirebaseCompendium.swift
//  NPCGen5e
//
//  Created by Michael Craun on 2/1/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import Firebase

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
    
    /// A hard reference to the core database on the Firebase database.
    private var ref_coreDatabase: DatabaseReference
    
    override init() {
        ref_coreDatabase = Database.database().reference().child(Key.database.key).child(Key.coreDB.key)
    }
    
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
        ref_coreDatabase.child("action").observeSingleEvent(of: .value) { (snapshot) in
            var actions = [Action]()
            guard let actionSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(actions, "Unable to find data!")
                return
            }
            
            for snap in actionSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let action = try JSONDecoder().decode(Action.self, from: json)
                    actions.append(action)
                    
                    if snap == actionSnapshot.last {
                        completion(actions, nil)
                    }
                } catch let error {
                    completion(actions, "ACTIONS: \(error)")
                }
            }
        }
    }
    
    private func fetchArmor(completion: @escaping ([Armor], Error?) -> Void) {
        ref_coreDatabase.child("armor").observeSingleEvent(of: .value) { (snapshot) in
            var armors = [Armor]()
            guard let armorSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(armors, "Unable to find data!")
                return
            }
            
            for snap in armorSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let armor = try JSONDecoder().decode(Armor.self, from: json)
                    armors.append(armor)
                    
                    if snap == armorSnapshot.last {
                        completion(armors, nil)
                    }
                } catch let error {
                    completion(armors, "ARMOR: \(error)")
                }
            }
        }
    }
    
    private func fetchOccupations(completion: @escaping ([Occupation], Error?) -> Void) {
        ref_coreDatabase.child("occupation").observeSingleEvent(of: .value) { (snapshot) in
            var occupations = [Occupation]()
            guard let occupationSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(occupations, "Unable to find data!")
                return
            }
            
            for snap in occupationSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let occupation = try JSONDecoder().decode(Occupation.self, from: json)
                    occupations.append(occupation)
                    
                    if snap == occupationSnapshot.last {
                        completion(occupations, nil)
                    }
                } catch let error {
                    completion(occupations, "OCCUPATIONS: \(error)")
                }
            }
        }
    }
    
    private func fetchRaces(completion: @escaping ([Race], Error?) -> Void) {
        ref_coreDatabase.child("race").observeSingleEvent(of: .value) { (snapshot) in
            var races = [Race]()
            guard let raceSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(races, "Unable to find data!")
                return
            }
            
            for snap in raceSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let race = try JSONDecoder().decode(Race.self, from: json)
                    races.append(race)
                    
                    if snap == raceSnapshot.last {
                        completion(races, nil)
                    }
                } catch let error {
                    completion(races, "RACES: \(error)")
                }
            }
        }
    }
    
    private func fetchSubraces(completion: @escaping ([Race.Subrace], Error?) -> Void) {
        ref_coreDatabase.child("subrace").observeSingleEvent(of: .value) { (snapshot) in
            var subraces = [Race.Subrace]()
            guard let subraceSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(subraces, "Unable to find data!")
                return
            }
            
            for snap in subraceSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let subrace = try JSONDecoder().decode(Race.Subrace.self, from: json)
                    subraces.append(subrace)
                    
                    if snap == subraceSnapshot.last {
                        completion(subraces, nil)
                    }
                } catch let error {
                    completion(subraces, "SUBRACES: \(error)")
                }
            }
        }
    }
    
    private func fetchTraits(completion: @escaping ([Trait], Error?) -> Void) {
        ref_coreDatabase.child("trait").observeSingleEvent(of: .value) { (snapshot) in
            var traits = [Trait]()
            guard let subraceSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(traits, "Unable to find data!")
                return
            }
            
            for snap in subraceSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let trait = try JSONDecoder().decode(Trait.self, from: json)
                    traits.append(trait)
                    
                    if snap == subraceSnapshot.last {
                        completion(traits, nil)
                    }
                } catch let error {
                    completion(traits, "TRAITS: \(error)")
                }
            }
        }
    }
    
    private func fetchWeapons(completion: @escaping ([Action], Error?) -> Void) {
        ref_coreDatabase.child("weapon").observeSingleEvent(of: .value) { (snapshot) in
            var weapons = [Action]()
            guard let subraceSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                completion(weapons, "Unable to find data!")
                return
            }
            
            for snap in subraceSnapshot {
                do {
                    let json = try JSONSerialization.data(withJSONObject: snap.value!, options: .prettyPrinted)
                    let action = try JSONDecoder().decode(Action.self, from: json)
                    weapons.append(action)
                    
                    if snap == subraceSnapshot.last {
                        completion(weapons, nil)
                    }
                } catch let error {
                    completion(weapons, "WEAPONS: \(error)")
                }
            }
        }
    }
}

// MARK: - NPCGen Assist specific functionality
extension FirebaseCompendium {
    typealias CoreDatabaseUploadCompletion = (Error?, DatabaseReference) -> Void
    
    private func put(data: [String : Any], on child: String, withUID uid: String, completion: @escaping CoreDatabaseUploadCompletion) {
        let ref = ref_coreDatabase.child(child).child(uid)
        ref.updateChildValues(data, withCompletionBlock: completion)
    }
    
//    private func removeData
    
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
        ref_coreDatabase.child("occupation").child(uid).getData { error, snap in
            if let error = error {
                print(error)
                return completion(nil)
            }
            
            completion(snap.value as? [String : Any])
        }
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
