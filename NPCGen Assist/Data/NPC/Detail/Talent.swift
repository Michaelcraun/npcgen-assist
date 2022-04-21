//
//  Talent.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/19/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

class Talent {
    private var skillLevels: [String] {
        return [
            "expertly",
            "like a well-trained rat",
            "masterfully",
            "poorly",
            "very well",
            "well",
            "with some proficiency"
        ]
    }
    private var instruments: [String] {
        return [
            "bagpipes",
            "citole",
            "drum",
            "dulcimer",
            "fiddle",
            "flute",
            "gittern",
            "lute",
            "lyre",
            "horn",
            "pan flute",
            "shawm",
            "viol"
        ]
    }
    private var skills: [String] {
        return [
            "dance",
            "draw",
            "juggle",
            "paint",
            "sew",
            "sing",
            "skip rocks",
            "throw darts"
        ]
    }
    private var miscellaneous: [String] {
        return [
            "has a perfect memory",
            "is unbeleivably lucky",
            "is a great cook",
            "is a skilled actor and master of disguise",
            "is an expert carpenter",
            "is great with animals",
            "is great with children",
            "is great at solving puzzles",
            "is great at impressions",
            "drinks everyone under the table",
            "speaks several languages fluently",
            "knows thieves' cant",
            "can make a potion out of anything"
        ]
    }
    
    private var instrument: String? {
        let hasInstrument = Bool.random()
        let instrument = "can play the \(randomItem(in: instruments)) \(randomItem(in: skillLevels))"
        return hasInstrument ? instrument : nil
    }
    private var skill: String? {
        let hasSkill = Bool.random()
        let skill = "can \(randomItem(in: skills)) \(randomItem(in: skillLevels))"
        return hasSkill ? skill : nil
    }
    private var miscellaneousSkill: String? {
        let hasMiscellaneous = Bool.random()
        return hasMiscellaneous ? randomItem(in: miscellaneous) : nil
    }
    private var npc: NPC
    
    /// A textual representation of the Appearance object.
    var description: String {
        var description: String = ""
        
        if let skill = skill {
            description += "$shortName \(skill). "
        }
        
        if let instrument = instrument {
            description += "$shortName \(instrument). "
        }
        
        if let miscellaneous = miscellaneousSkill {
            description += "$shortName \(miscellaneous). "
        }
        
        return description == "" ? ("$shortName isn't good at anything.").replacingPlaceholders(with: npc) : description.replacingPlaceholders(with: npc)
    }
    
    init(npc: NPC) {
        self.npc = npc
    }
}
