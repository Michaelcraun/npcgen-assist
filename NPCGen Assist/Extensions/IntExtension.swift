//
//  IntExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 10/1/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Int {
    var inMegabytes: Int64 {
        return Int64(self * 1024 * 1024)
    }
    
    var identifier: String {
        return "\(self)"
    }
    
    var level: String {
        switch self {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: break
        }
        return "\(self)th"
    }
    
    var filterDescription: String {
        return ""
    }
    
    var filterTitle: String {
        return "\(self.withCommas())"
    }
    
    /// The modifier of a given ability.
    var abilityModifier: Int {
        return Int((Double(self) / 2).rounded(.down)) - 5
    }
    
    /// The description of an ability, such as Strength.
    var abilityDescription: String {
        if self < 10 {
            return "\(self) (\(self.abilityModifier))"
        } else {
            return "\(self) (+\(self.abilityModifier))"
        }
    }
    
    ///A String representation of a bonus.
    var modifier: String {
        if self < 0 {
            return "\(self)"
        } else {
            return "+\(self)"
        }
    }
    
    func withCommas() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self))!
    }
}

extension Array where Element == Int {
    func greatest() -> Int {
        guard self.count > 0 else { return 0 }
        return self.sorted().first!
    }
}
