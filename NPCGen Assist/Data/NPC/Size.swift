//
//  Size.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Size: String {
    case tiny
    case small
    case medium
    case large
    case huge
    
    var speedBonus: Int {
        switch self {
        case .tiny: return -10
        case .small: return -5
        case .medium: return 0
        case .large: return 5
        case .huge: return 10
        }
    }
    
    var shortHand: String {
        switch self {
        case .tiny: return "T"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .huge: return "H"
        }
    }
}
