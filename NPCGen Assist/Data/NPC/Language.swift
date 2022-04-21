//
//  Language.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Language: String, CaseIterable {
    case abyssal
    case celestial
    case common
    case deepSpeech = "deep speech"
    case draconic
    case dwarvish
    case elvish
    case giant
    case gnomish
    case goblin
    case halfling
    case infernal
    case orc
    case primordial
    case sylvan
    case undercommon
    
    static func random(ignoring: [Language]) -> Language {
        let possibleLanguages = allCases.removingExisting(ignoring)
        return possibleLanguages.randomElement()!
    }
    
    func description() -> String {
        return self.rawValue.capitalized
    }
}
