//
//  NPCGen_AssistTests.swift
//  NPCGen AssistTests
//
//  Created by Michael Craun on 4/21/22.
//

import XCTest
@testable import NPCGen_Assist

class NPCGen_AssistTests: XCTestCase {
    
    override func setUp(completion: @escaping (Error?) -> Void) {
        guard let credFilePath = Bundle.main.path(forResource: "firebase", ofType: "json") else {
            print("no credentials file found")
            return
        }
        
        let url = URL(fileURLWithPath: credFilePath)
        guard let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String : String],
              let email = json["username"],
              let password = json["password"] else {
            print("unable to parse credentials file!!")
            return
        }
        
        FirebaseManager.authorization.signin(email: email, password: password) { user, error in
            guard let error = error else { return completion(nil) }
            print(error.localizedDescription)
            completion(error)
        }
    }
    
    func testGetOccupationData() {
        class OccupationData: CustomStringConvertible {
            let name: String
            var abis: [String : Int] = [:]
            
            init(name: String) {
                self.name = name
            }
            
            var description: String {
                """
                {
                    "OccupationData" : {
                        "name": "\(name)",
                        "abis": \(abis)
                    }
                }
                """
            }
        }
        
        let expectation = XCTestExpectation(description: "finished fetching data")
        let dispatchGroup = DispatchGroup()
        
        var collatedData: [OccupationData] = []
        
        FirebaseManager.compendium.initializeCoreCompendium { success, error in
            for occupation in Compendium.instance.occupations {
                let occData = OccupationData(name: occupation.filterTitle)
                occData.abis["1"] = occupation.data?._first?.abilityModifiers.total()
                occData.abis["2"] = occupation.data?._second?.abilityModifiers.total()
                occData.abis["3"] = occupation.data?._third?.abilityModifiers.total()
                occData.abis["4"] = occupation.data?._fourth?.abilityModifiers.total()
                occData.abis["5"] = occupation.data?._fifth?.abilityModifiers.total()
                occData.abis["6"] = occupation.data?._sixth?.abilityModifiers.total()
                occData.abis["7"] = occupation.data?._seventh?.abilityModifiers.total()
                occData.abis["8"] = occupation.data?._eighth?.abilityModifiers.total()
                occData.abis["9"] = occupation.data?._ninth?.abilityModifiers.total()
                occData.abis["10"] = occupation.data?._tenth?.abilityModifiers.total()
                occData.abis["11"] = occupation.data?._eleventh?.abilityModifiers.total()
                occData.abis["12"] = occupation.data?._twelfth?.abilityModifiers.total()
                occData.abis["13"] = occupation.data?._thirteenth?.abilityModifiers.total()
                occData.abis["14"] = occupation.data?._fourteenth?.abilityModifiers.total()
                occData.abis["15"] = occupation.data?._fifteenth?.abilityModifiers.total()
                occData.abis["16"] = occupation.data?._sixteenth?.abilityModifiers.total()
                occData.abis["17"] = occupation.data?._seventeenth?.abilityModifiers.total()
                occData.abis["18"] = occupation.data?._eighteenth?.abilityModifiers.total()
                occData.abis["19"] = occupation.data?._nineteenth?.abilityModifiers.total()
                occData.abis["20"] = occupation.data?._twentieth?.abilityModifiers.total()
                
                collatedData.append(occData)
            }
            
            print(collatedData)
            
            dispatchGroup.notify(queue: .main) {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 15)
    }
}
