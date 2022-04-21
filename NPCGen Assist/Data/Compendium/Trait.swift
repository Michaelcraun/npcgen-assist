//
//  CompendiumTrait.swift
//  NPCGen5e
//
//  Created by Michael Craun on 8/25/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

struct Trait: Codable, Identifiable {
    var identifier: String
    
    /// The description of the Trait object.
    var _description: String
    
    /// The title of the Trait object.
    var title: String
}

extension Array where Element == Trait {
    /// Iterrates through a list of Compendium.Trait, replacing placeholders with the correct values obtained from the CompendiumNPC, and removing extraneous traits
    /// - parameter npc: The instance of CompendiumNPC to modify the list of Compendium.Trait for.
    func forNPC(_ npc: NPC) -> [Trait] {
        var traits = [Trait]()
        for (index, trait) in self.enumerated() {
            traits.append(trait)
            traits[index]._description = trait._description.replacingPlaceholders(with: npc)
        }
        return traits
    }
}
