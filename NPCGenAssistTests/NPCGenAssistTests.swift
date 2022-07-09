//
//  NPCGenAssistTests.swift
//  NPCGenAssistTests
//
//  Created by Michael Craun on 7/9/22.
//

import XCTest
@testable import NPCGen_Assist

class NPCGenAssistTests: XCTestCase {
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
    
    func load(file: String, extension ext: String) -> String? {
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(testFile: file, withExtension: ext),
            let contents = try? String(contentsOf: fileURL) else {
                return nil
        }
        return contents
    }
    
    func loadJsonFile(named name: String) -> [String : Any]? {
        guard let json = load(file: name, extension: "json") else { return nil }
        guard let data = json.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any]
    }
}
