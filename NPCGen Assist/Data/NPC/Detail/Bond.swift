//
//  Bond.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/19/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Bond {
    private var npc: NPC
    private var bonds: [String] {
        return [
            "is dedicated to fulfilling a personal life goal",
            "is protective of close family members",
            "is protective of colleagues or compatriots",
            "is loyal to a benefactor, patron, or employer",
            "is captivated by a romantic interest",
            "is drawn to a special place",
            "is protective of a sentimental keepsake",
            "is protective of a valuable possession",
            "is seeking revenge for the death of a loved one",
            "has been hexed into becoming minuscule",
            "is searching for $alternatePronoun soul mate",
            "is being haunted by a ghost",
            "is secretly a cannibal"
        ]
    }
    
    /// A textual representation of the Appearance object.
    var description: String {
        return "$shortName \(randomItem(in: bonds)).".replacingPlaceholders(with: npc)
    }
    
    init(npc: NPC) {
        self.npc = npc
    }
}
