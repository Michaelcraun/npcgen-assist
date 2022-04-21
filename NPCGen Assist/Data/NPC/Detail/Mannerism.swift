//
//  Mannerism.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/19/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Mannerism {
    private var behaviors: [String] {
        return [
            "is prone to singing, whistling, or humming quietly",
            "is prone to predictions of doom",
            "fidgets frequently while in social situations",
            "squints frequently",
            "frequently trails off to stare into the distance",
            "is constantly chewing something",
            "bites their fingernails when not speaking",
            "constantly twirls or tugs on $alternatePronoun hair or beard",
            "holds grudges for a ridiculously long time",
            "rarely thinks before acting",
            "stretches the truth to tell a good story",
            "has a crude sense of humor",
            "is very good at keeping secrets",
            "argues about everything, no matter how small"
        ]
    }
    private var speeches: [String] {
        return [
            "always speaks in rhyme",
            "speaks with a very deep voice",
            "speaks with a very high voice",
            "slurs words when talking",
            "has a terrible lisp",
            "stutters frequently when talking",
            "enunciates words overly clearly",
            "always whispers when speaking",
            "uses flowery speech",
            "uses incredibly long words when speaking",
            "frequently uses the wrong words",
            "uses colorful oaths and exclamations",
            "constantly makes jokes and puns",
            "paces fervently while talking",
            "taps their fingers when speaking",
            "bites their fingernails when speaking",
            "always speaks loudly, as though $pronoun can't be heard"
        ]
    }
    private var npc: NPC
    
    /// A textual representation of the Appearance object.
    var description: String {
        return "$shortName \(randomItem(in: behaviors)) and \(randomItem(in: speeches)).".replacingPlaceholders(with: npc)
    }
    
    init(npc: NPC) {
        self.npc = npc
    }
}
