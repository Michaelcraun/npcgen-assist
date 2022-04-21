//
//  Flaw.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/19/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Flaw {
    private var hasPhobia: Bool {
        return randomItem(in: [true, false, false, false])
    }
    private var flaws: [String] {
        return [
            "has a forbidden love",
            "is easily susceptibile to romance",
            "envies another creature's possessions or station",
            "has a shameful or scandalous history and is willing to do anything to keep it secret",
            "has commited a secret crime or misdeed and is willing to do anything to keep it secret",
            "has a constant wanderlust and is unable to live at the same place for more than a few months",
            "often offends other people with $alternatePronoun arrogance",
            "suffers from overpowering greed",
            "is prone to blinding rage",
            "suffers from foolhardy bravery",
            "is extremely lazy and selfish",
            "is very conceited"
        ]
    }
    private var phobias: [String] {
        return [
            "being alone",
            "cats",
            "dogs",
            "elves",
            "heights",
            "insects",
            "large crowds",
            "snakes",
            "spiders",
            "thunder"
        ]
    }
    private var npc: NPC
    
    /// A textual representation of the Appearance object.
    var description: String {
        let flaw = randomItem(in: flaws)
        if hasPhobia {
            let phobia = randomItem(in: phobias)
            return "$shortName \(flaw) and is afraid of \(phobia).".replacingPlaceholders(with: npc)
        } else {
            return "$shortName \(flaw).".replacingPlaceholders(with: npc)
        }
    }
    
    init(npc: NPC) {
        self.npc = npc
    }
}
