//
//  GenerationTests.swift
//  NPCGenAssistTests
//
//  Created by Michael Craun on 7/9/22.
//

import XCTest
@testable import NPCGen_Assist
@testable import Firebase

class GenerationTests: NPCGenAssistTests {
    func uploadOccupation(from file: String, completion: @escaping (Error?) -> Void) {
        let group = DispatchGroup()
        
        guard var dict = loadJsonFile(named: file) else { return XCTFail() }
        guard let occupation = dict["occupation"] as? [String : Any] else {
            return completion("No occupation specified, but occupation is required!")
        }
        
        var completedUploads: [DatabaseReference] = []
        var failed: Bool = false
        
        group.enter()
        let uuid = UUID().uuidString
        dict["uid"] = uuid
        
        FirebaseManager.compendium.putOccupation(uid: uuid, data: occupation) { error, reference  in
            if let error = error {
                failed = true
                print(error.localizedDescription)
            }
            completedUploads.append(reference)
            group.leave()
        }
        
        if let traits = dict["traits"] as? [[String : Any]], !traits.isEmpty {
            for trait in traits {
                var mutable = trait
                let uid = UUID().uuidString
                mutable["uid"] = uid
                
                group.enter()
                FirebaseManager.compendium.putTrait(uid: uid, data: mutable) { error, reference in
                    if let error = error {
                        failed = true
                        print(error.localizedDescription)
                    }
                    completedUploads.append(reference)
                    group.leave()
                }
            }
        }
        
        if let actions = dict["actions"] as? [[String : Any]], !actions.isEmpty {
            for action in actions {
                var mutable = action
                let uid = UUID().uuidString
                mutable["uid"] = uid
                
                group.enter()
                FirebaseManager.compendium.putAction(uid: uid, data: mutable) { error, reference in
                    if let error = error {
                        failed = true
                        print(error.localizedDescription)
                    }
                    completedUploads.append(reference)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if failed {
                print("At least one upload failed, removing all completed uploads...")
                let group = DispatchGroup()
                for upload in completedUploads {
                    group.enter()
                    upload.removeValue { error, reference in
                        if let error = error {
                            print("Couldn't remove reference at \(reference.url), please remove it manually!")
                            print(error.localizedDescription)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    return completion(nil)
                }
            } else {
                return completion(nil)
            }
        }
    }
    
    func testOccupationUploadFromJson() {
        let expectation = XCTestExpectation(description: "uploaded successfully")
        
        uploadOccupation(from: "occupation-upload-example") { error in
            if let error = error {
                return XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 60)
    }
    
    func testUploadEntertainer() {
        let expectation = XCTestExpectation(description: "uploaded successfully")
        
        uploadOccupation(from: "occupation-entertainer") { error in
            if let error = error {
                return XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 60)
    }
    
    func testCreationAndUpload() {
        let occupation = Occupation(
            name: "entertainer",
            description: "Scholars, skalds, and storytellers alike pride themselves on their ability to keep the mind engaged in a variety of joyous abilities.",
            armors: ["light"],
            weapons: ["simple, handCrossbow", "longsword", "rapier", "shortsword"],
            levelData: Compendium.LevelData(
                data: [
                    1: Compendium.LevelData.Data(
                        level: 1,
                        title: "",
                        abilityModifiers: [.cha(modifier: 2)],
                        saves: [.dex, .cha],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    2: Compendium.LevelData.Data(
                        level: 2,
                        title: "",
                        abilityModifiers: [.cha(modifier: 2)],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    3: Compendium.LevelData.Data(
                        level: 3,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    4: Compendium.LevelData.Data(
                        level: 4,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    5: Compendium.LevelData.Data(
                        level: 5,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    6: Compendium.LevelData.Data(
                        level: 6,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    7: Compendium.LevelData.Data(
                        level: 7,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    8: Compendium.LevelData.Data(
                        level: 8,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    9: Compendium.LevelData.Data(
                        level: 9,
                        title: "",
                        abilityModifiers: [],
                        saves: [],
                        skills: [],
                        challengeModifiers: <#T##[String]?#>,
                        traits: <#T##[String]?#>
                    ),
                    10: Compendium.LevelData.Data(
                        level: 10,
                        title: "",
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    11: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    12: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    13: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    14: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    15: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    16: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    17: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    18: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    19: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    ),
                    20: Compendium.LevelData.Data(
                        level: <#T##Int#>,
                        title: <#T##String#>,
                        abilityModifiers: <#T##[String]#>,
                        saves: <#T##[String]#>,
                        skills: <#T##[String]#>,
                        armors: <#T##[String]?#>,
                        challengeModifiers: <#T##[String]?#>,
                        conditionImmunities: <#T##[String]?#>,
                        damageResistances: <#T##[String]?#>,
                        traits: <#T##[String]?#>,
                        truesight: <#T##Int?#>
                    )
                ]
            )
        )
    }
}
