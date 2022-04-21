//
//  AuthenticationServicesExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 2/1/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import AuthenticationServices

@available(iOS 13.0, *)
extension ASAuthorizationAppleIDCredential {
    var username: String {
        let characters = self.user.removingCharacters(["."])
        var result: String = ""
        for _ in 0..<10 {
            let char = characters.randomElement()!
            result.append(char)
        }
        return "user\(result.uppercased())"
    }
}
