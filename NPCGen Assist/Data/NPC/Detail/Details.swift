//
//  Shared.swift
//  NPCGenerator
//
//  Created by Michael Craun on 9/2/17.
//  Copyright © 2017 Craunic Productions. All rights reserved.
//

import Foundation

class Details: Codable {
    /// The NPC object that the Details object is being constructed for.
    private var npc: NPC
    
    /// A random selection from the Appearance object.
    private var _appearance: Appearance {
        return Appearance(npc: npc)
    }
    
    /// A random selection from the Bond object.
    private var _bond: Bond {
        return Bond(npc: npc)
    }
    
    /// A random selection from the Flaw object.
    private var _flaw: Flaw {
        return Flaw(npc: npc)
    }
    
    /// A random selection from the Mannerism object.
    private var _mannerism: Mannerism {
        return Mannerism(npc: npc)
    }
    
    /// A random selection from the Talent object.
    private var _talent: Talent {
        return Talent(npc: npc)
    }
    
    /// A textual representation of the Details object used when exporting an NPC object.
    var notes: String {
        return """
        \(npc.name) has the following roleplaying notes:
            Mannerism. \(mannerism.replacingPlaceholders(with: npc))
            Talent. \(talent.replacingPlaceholders(with: npc))
            Bond. \(bond.replacingPlaceholders(with: npc))
            Flaw. \(flaw.replacingPlaceholders(with: npc))
            Appearance. \(appearance.replacingPlaceholders(with: npc))
        """
    }
    
    /// The appearance of the NPC object.
    var appearance: String = ""
    
    /// The bond of the NPC object.
    var bond: String = ""
    
    /// The flaw of the NPC object.
    var flaw: String = ""
    
    /// The mannerism of the NPC object.
    var mannerism: String = ""
    
    /// The talent of the NPC object.
    var talent: String = ""
    
    /// The default initializer for the Details object.
    /// - To construct the Details object with previously obtained values, pass those values into their associated objects.
    /// - Parameters:
    ///   - npc: The NPC object the Details object is being constructed for.
    ///   - appearance: The NPC's preexisting appearance, if any.
    ///   - bond: The NPC's preexisting bond, if any.
    ///   - flaw: The NPC's preexisting flaw, if any.
    ///   - mannerism: The NPC's preexisting mannerism, if any.
    ///   - talent: The NPC's preexisting talent, if any.
    init(npc: NPC, appearance: String? = nil, bond: String? = nil, flaw: String? = nil, mannerism: String? = nil, talent: String? = nil) {
        self.npc = npc
        self.appearance = appearance ?? _appearance.description
        self.bond = bond ?? _bond.description
        self.flaw = flaw ?? _flaw.description
        self.mannerism = mannerism ?? _mannerism.description
        self.talent = talent ?? _talent.description
    }
}

/// Selects a random integer between 0 and a designated number.
/// - Parameter upperBound: The designated number.
/// - Returns: An integer between 0 and the designated number.
func randomValue(upperBound: Int) -> Int {
    return Int.random(in: 0...upperBound)
}

/// Selects a random element within an Array of objects.
/// - Parameter items: The Array of objects to select from.
/// - Returns: A random element.
func randomItem<T>(in items: [T]) -> T {
    let randomIndex = Int.random(in: 0..<items.count)
    let selectedItem = items[randomIndex]
    return selectedItem
}
