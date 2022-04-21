//
//  Die.swift
//  NPCGen5e
//
//  Created by Michael Craun on 11/17/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

enum Die {
    case d4(numOfDice: Int)
    case d6(numOfDice: Int)
    case d8(numOfDice: Int)
    case d10(numOfDice: Int)
    case d12(numOfDice: Int)
    
    var numberOfDice: Int {
        switch self {
        case .d4(let numOfDice): return numOfDice
        case .d6(let numOfDice): return numOfDice
        case .d8(let numOfDice): return numOfDice
        case .d10(let numOfDice): return numOfDice
        case .d12(let numOfDice): return numOfDice
        }
    }
    
    var average: Double {
        switch self {
        case .d4(let num):  return 2.5 * Double(num)
        case .d6(let num):  return 3.5 * Double(num)
        case .d8(let num):  return 4.5 * Double(num)
        case .d10(let num): return 5.5 * Double(num)
        case .d12(let num): return 6.5 * Double(num)
        }
    }
    
    var title: String {
        switch self {
        case .d4(let num): return "\(num)d4"
        case .d6(let num): return "\(num)d6"
        case .d8(let num): return "\(num)d8"
        case .d10(let num): return "\(num)d10"
        case .d12(let num): return "\(num)d12"
        }
    }
    
    func adding(_ value: Int) -> Int {
        switch self {
        case .d4(let numOfDice), .d6(let numOfDice), .d8(let numOfDice), .d10(let numOfDice), .d12(let numOfDice):
            return Int(average) * numOfDice + value
        }
    }
    
    mutating func increase() {
        switch self {
        case .d4(let numOfDice): self = .d4(numOfDice: numOfDice + 1)
        case .d6(let numOfDice): self = .d6(numOfDice: numOfDice + 1)
        case .d8(let numOfDice): self = .d8(numOfDice: numOfDice + 1)
        case .d10(let numOfDice): self = .d10(numOfDice: numOfDice + 1)
        case .d12(let numOfDice): self = .d12(numOfDice: numOfDice + 1)
        }
    }
    
    func next() -> Die {
        switch self {
        case .d4(let num): return .d6(numOfDice: num)
        case .d6(let num): return .d8(numOfDice: num)
        case .d8(let num): return .d10(numOfDice: num)
        case .d10(let num): return .d12(numOfDice: num)
        case .d12(let num): return .d6(numOfDice: num + 1)
        }
    }
    
    init?(description: String) {
        let components = description.components(separatedBy: "d")
        if components.count == 2 {
            guard let numOfDice = Int(components[0]),
                let die = Int(components[1]) else { return nil }
            switch die {
            case 4: self = .d4(numOfDice: numOfDice)
            case 6: self = .d6(numOfDice: numOfDice)
            case 8: self = .d8(numOfDice: numOfDice)
            case 10: self = .d10(numOfDice: numOfDice)
            case 12: self = .d12(numOfDice: numOfDice)
            default: return nil
            }
        } else {
            return nil
        }
    }
}
