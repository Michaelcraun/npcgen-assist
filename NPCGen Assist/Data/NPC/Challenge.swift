//
//  Challenge.swift
//  NPCGen5e
//
//  Created by Michael Craun on 9/13/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}

extension Challenge: Comparable {
    static func == (lhs: Challenge, rhs: Challenge) -> Bool {
        return lhs.xpValue == rhs.xpValue
    }
    
    static func > (lhs: Challenge, rhs: Challenge) -> Bool {
        return lhs.xpValue > rhs.xpValue
    }
    
    static func < (lhs: Challenge, rhs: Challenge) -> Bool {
        return lhs.xpValue < rhs.xpValue
    }
}

extension Challenge: Strideable {
    typealias Stride = Int
    
    func distance(to other: Challenge) -> Stride {
        return Stride(other.xpValue) - Stride(self.xpValue)
    }
    
    func advanced(by n: Int) -> Challenge {
        var challenge = self
        for _ in 0..<n {
            if challenge == Challenge.allCases.last {
                fatalError("Index out of bounds")
            } else {
                challenge.next()
            }
        }
        return challenge
    }
}

enum Challenge: String, CaseIterable, Codable, Hashable {
    enum Modifier: Equatable {
        case ac(formula: String)
        case attack(formula: String)
        case damage(formula: String)
        case hp(formula: String)
    }
    
    case zero
    case oneEighth
    case oneFourth
    case oneHalf
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case eleven
    case twelve
    case thirteen
    case fourteen
    case fifteen
    case sixteen
    case seventeen
    case eighteen
    case nineteen
    case twenty
    case twentyOne
    case twentyTwo
    case twentyThree
    case twentyFour
    case twentyFive
    case twentySix
    case twentySeven
    case twentyEight
    case twentyNine
    case thirty
    
    private init?(hitPoints: Int) {
        switch hitPoints {
        case 1...6: self = .zero
        case 7...35: self = .oneEighth
        case 36...49: self = .oneFourth
        case 50...70: self = .oneHalf
        case 71...85: self = .one
        case 86...100: self = .two
        case 101...115: self = .three
        case 116...130: self = .four
        case 131...145: self = .five
        case 146...160: self = .six
        case 161...175: self = .seven
        case 176...190: self = .eight
        case 191...205: self = .nine
        case 206...220: self = .ten
        case 221...235: self = .eleven
        case 236...250: self = .twelve
        case 251...265: self = .thirteen
        case 266...280: self = .fourteen
        case 281...295: self = .fifteen
        case 296...310: self = .sixteen
        case 311...325: self = .seventeen
        case 326...340: self = .eighteen
        case 341...355: self = .nineteen
        case 356...400: self = .twenty
        case 401...445: self = .twentyOne
        case 446...490: self = .twentyTwo
        case 491...535: self = .twentyThree
        case 536...580: self = .twentyFour
        case 581...625: self = .twentyFive
        case 626...670: self = .twentySix
        case 671...715: self = .twentySeven
        case 716...760: self = .twentyEight
        case 761...805: self = .twentyNine
        case 806...850: self = .thirty
        default: return nil
        }
    }
    
    private init?(damagePerRound: Int) {
        switch damagePerRound {
        case 0...1: self = .zero
        case 2...3: self = .oneEighth
        case 4...5: self = .oneFourth
        case 6...8: self = .oneHalf
        case 9...14: self = .one
        case 15...20: self = .two
        case 21...26: self = .three
        case 27...32: self = .four
        case 33...38: self = .five
        case 39...44: self = .six
        case 45...50: self = .seven
        case 51...56: self = .eight
        case 57...62: self = .nine
        case 63...68: self = .ten
        case 69...74: self = .eleven
        case 75...80: self = .twelve
        case 81...86: self = .thirteen
        case 87...92: self = .fourteen
        case 93...98: self = .fifteen
        case 99...104: self = .sixteen
        case 105...110: self = .seventeen
        case 111...116: self = .eighteen
        case 117...122: self = .nineteen
        case 123...140: self = .twenty
        case 141...158: self = .twentyOne
        case 159...176: self = .twentyTwo
        case 177...194: self = .twentyThree
        case 195...212: self = .twentyFour
        case 213...230: self = .twentyFive
        case 231...248: self = .twentySix
        case 249...266: self = .twentySeven
        case 267...284: self = .twentyEight
        case 285...302: self = .twentyNine
        case 303...320: self = .thirty
        default: return nil
        }
    }
    
    private init(rating: Double) {
        switch rating {
        case 0.000...0.124: self = .zero
        case 0.125...0.249: self = .oneEighth
        case 0.250...0.499: self = .oneFourth
        case 0.500...0.999: self = .oneHalf
        case 1.000...1.999: self = .one
        case 2.000...2.999: self = .two
        case 3.000...3.999: self = .three
        case 4.000...4.999: self = .four
        case 5.000...5.999: self = .five
        case 6.000...6.999: self = .six
        case 7.000...7.999: self = .seven
        case 8.000...8.999: self = .eight
        case 9.000...9.999: self = .nine
        case 10.00...10.99: self = .ten
        case 11.00...11.99: self = .eleven
        case 12.00...12.99: self = .twelve
        case 13.00...13.99: self = .thirteen
        case 14.00...14.99: self = .fourteen
        case 15.00...15.99: self = .fifteen
        case 16.00...16.99: self = .sixteen
        case 17.00...17.99: self = .seventeen
        case 18.00...18.99: self = .eighteen
        case 19.00...19.99: self = .nineteen
        case 20.00...20.99: self = .twenty
        case 21.00...21.99: self = .twentyOne
        case 22.00...22.99: self = .twentyTwo
        case 23.00...23.99: self = .twentyThree
        case 24.00...24.99: self = .twentyFour
        case 25.00...25.99: self = .twentyFive
        case 26.00...26.99: self = .twentySix
        case 27.00...27.99: self = .twentySeven
        case 28.00...28.99: self = .twentyEight
        case 29.00...29.99: self = .twentyNine
        default:            self = .thirty
        }
    }
    
    var armorClass: ClosedRange<Int> {
        switch self {
        case .zero: return 12...14
        case .oneEighth: return 12...14
        case .oneFourth: return 12...14
        case .oneHalf: return 12...14
        case .one: return 12...14
        case .two: return 12...14
        case .three: return 12...14
        case .four: return 13...15
        case .five: return 14...16
        case .six: return 14...16
        case .seven: return 14...16
        case .eight: return 15...17
        case .nine: return 15...17
        case .ten: return 16...18
        case .eleven: return 16...18
        case .twelve: return 16...18
        case .thirteen: return 17...19
        case .fourteen: return 17...19
        case .fifteen: return 17...19
        case .sixteen: return 17...19
        default: return 18...20
        }
    }
    
    var attackBonus: ClosedRange<Int> {
        switch self {
        case .zero: return 2...4
        case .oneEighth: return 2...4
        case .oneFourth: return 2...4
        case .oneHalf: return 2...4
        case .one: return 2...4
        case .two: return 2...4
        case .three: return 3...5
        case .four: return 4...6
        case .five: return 5...7
        case .six: return 5...7
        case .seven: return 5...7
        case .eight: return 6...8
        case .nine: return 6...8
        case .ten: return 6...8
        case .eleven: return 7...9
        case .twelve: return 7...9
        case .thirteen: return 7...9
        case .fourteen: return 7...9
        case .fifteen: return 7...9
        case .sixteen: return 8...10
        case .seventeen: return 9...11
        case .eighteen: return 9...11
        case .nineteen: return 9...11
        case .twenty: return 9...11
        case .twentyOne: return 10...12
        case .twentyTwo: return 10...12
        case .twentyThree: return 10...12
        case .twentyFour: return 11...13
        case .twentyFive: return 11...13
        case .twentySix: return 11...13
        case .twentySeven: return 12...14
        case .twentyEight: return 12...14
        case .twentyNine: return 12...14
        case .thirty: return 13...15
        }
    }
    
    var proficiency: Int {
        return Int((self.rating.asDouble() / 4.1).rounded(.down)) + 2
    }
    
    var rating: String {
        switch self {
        case .zero:         return "0"
        case .oneEighth:    return "1/8"
        case .oneFourth:    return "1/4"
        case .oneHalf:      return "1/2"
        case .one:          return "1"
        case .two:          return "2"
        case .three:        return "3"
        case .four:         return "4"
        case .five:         return "5"
        case .six:          return "6"
        case .seven:        return "7"
        case .eight:        return "8"
        case .nine:         return "9"
        case .ten:          return "10"
        case .eleven:       return "11"
        case .twelve:       return "12"
        case .thirteen:     return "13"
        case .fourteen:     return "14"
        case .fifteen:      return "15"
        case .sixteen:      return "16"
        case .seventeen:    return "17"
        case .eighteen:     return "18"
        case .nineteen:     return "19"
        case .twenty:       return "20"
        case .twentyOne:    return "21"
        case .twentyTwo:    return "22"
        case .twentyThree:  return "23"
        case .twentyFour:   return "24"
        case .twentyFive:   return "25"
        case .twentySix:    return "26"
        case .twentySeven:  return "27"
        case .twentyEight:  return "28"
        case .twentyNine:   return "29"
        case .thirty:       return "30"
        }
    }
    
    var xpValue: Int {
        switch self {
        case .zero:         return 10
        case .oneEighth:    return 25
        case .oneFourth:    return 50
        case .oneHalf:      return 100
        case .one:          return 200
        case .two:          return 450
        case .three:        return 700
        case .four:         return 1100
        case .five:         return 1800
        case .six:          return 2300
        case .seven:        return 2900
        case .eight:        return 3900
        case .nine:         return 5000
        case .ten:          return 5900
        case .eleven:       return 7200
        case .twelve:       return 8400
        case .thirteen:     return 10000
        case .fourteen:     return 11500
        case .fifteen:      return 13000
        case .sixteen:      return 15000
        case .seventeen:    return 18000
        case .eighteen:     return 20000
        case .nineteen:     return 22000
        case .twenty:       return 25000
        case .twentyOne:    return 33000
        case .twentyTwo:    return 41000
        case .twentyThree:  return 50000
        case .twentyFour:   return 62000
        case .twentyFive:   return 75000
        case .twentySix:    return 90000
        case .twentySeven:  return 105000
        case .twentyEight:  return 120000
        case .twentyNine:   return 135000
        case .thirty:       return 155000
        }
    }
    
    mutating func next() {
        switch self {
        case .zero: self = .oneEighth
        case .oneEighth: self = .oneFourth
        case .oneFourth: self = .oneHalf
        case .oneHalf: self = .one
        case .one: self = .two
        case .two: self = .three
        case .three: self = .four
        case .four: self = .five
        case .five: self = .six
        case .six: self = .seven
        case .seven: self = .eight
        case .eight: self = .nine
        case .nine: self = .ten
        case .ten: self = .eleven
        case .eleven: self = .twelve
        case .twelve: self = .thirteen
        case .thirteen: self = .fourteen
        case .fourteen: self = .fifteen
        case .fifteen: self = .sixteen
        case .sixteen: self = .seventeen
        case .seventeen: self = .eighteen
        case .eighteen: self = .nineteen
        case .nineteen: self = .twenty
        case .twenty: self = .twentyOne
        case .twentyOne: self = .twentyTwo
        case .twentyTwo: self = .twentyThree
        case .twentyThree: self = .twentyFour
        case .twentyFour: self = .twentyFive
        case .twentyFive: self = .twentySix
        case .twentySix: self = .twentySeven
        case .twentySeven: self = .twentyEight
        case .twentyEight: self = .twentyNine
        case .twentyNine: self = .thirty
        case .thirty: self = .thirty
        }
    }
    
    mutating func previous() {
        switch self {
        case .zero: self = .zero
        case .oneEighth: self = .zero
        case .oneFourth: self = .oneEighth
        case .oneHalf: self = .oneFourth
        case .one: self = .oneHalf
        case .two: self = .one
        case .three: self = .two
        case .four: self = .three
        case .five: self = .four
        case .six: self = .five
        case .seven: self = .six
        case .eight: self = .seven
        case .nine: self = .eight
        case .ten: self = .nine
        case .eleven: self = .ten
        case .twelve: self = .eleven
        case .thirteen: self = .twelve
        case .fourteen: self = .thirteen
        case .fifteen: self = .fourteen
        case .sixteen: self = .fifteen
        case .seventeen: self = .sixteen
        case .eighteen: self = .seventeen
        case .nineteen: self = .eighteen
        case .twenty: self = .nineteen
        case .twentyOne: self = .twenty
        case .twentyTwo: self = .twentyOne
        case .twentyThree: self = .twentyTwo
        case .twentyFour: self = .twentyThree
        case .twentyFive: self = .twentyFour
        case .twentySix: self = .twentyFive
        case .twentySeven: self = .twentySix
        case .twentyEight: self = .twentySeven
        case .twentyNine: self = .twentyEight
        case .thirty: self = .twentyNine
        }
    }
    
    static func average(defensive: Challenge, offensive: Challenge) -> Challenge {
        let defensiveRating = defensive.rating.asDouble()
        let offensiveRating = offensive.rating.asDouble()
        if defensiveRating == offensiveRating {
            return defensive
        } else {
            if offensiveRating > defensiveRating {
                let difference = (offensiveRating - defensiveRating) / 2
                return Challenge(rating: difference + defensiveRating)
            } else {
                let difference = (defensiveRating - offensiveRating) / 2
                return Challenge(rating: difference + offensiveRating)
            }
        }
    }
    
    static func range(for occupations: [Occupation] = Compendium.instance.occupations, and races: [Race] = Compendium.instance.races) -> ClosedRange<Challenge> {
        if occupations.count == Compendium.instance.occupations.count && races.count == Compendium.instance.races.count {
            var range: ClosedRange<Challenge> = .zero...(.oneEighth)
            for occupation in occupations {
                let _range = occupation.challengeRange()
                if _range.count > range.count {
                    range = _range
                }
            }
            
            for race in races {
                let _range = race.challengeRange()
                if _range.count > range.count {
                    range = _range
                }
            }
            return range
        } else {
            let occupationChallenges = clampedRange(for: occupations)
            let raceChallenges = clampedRange(for: races)
            return raceChallenges.clamped(to: occupationChallenges)
        }
    }
    
    static func calculate(hitPoints: Int, armorClass: Int, attackBonus: Int, damagePerRound: Int) -> Challenge {
        guard let defensive = defensiveChallenge(hitPoints: hitPoints, armorClass: armorClass),
            let offensive = offensiveChallenge(attackBonus: attackBonus, damagePerRound: damagePerRound) else {
                return .zero
        }
        return average(defensive: defensive, offensive: offensive)
    }
    
    static private func clampedRange(for occupations: [Occupation]) -> ClosedRange<Challenge> {
        var challenges = Challenge.allCases.first!...Challenge.allCases.last!
        for occupation in occupations {
            challenges = challenges.clamped(to: occupation.challengeRange())
        }
        return challenges
    }
    
    static private func clampedRange(for races: [Race]) -> ClosedRange<Challenge> {
        var challenges = Challenge.allCases.first!...Challenge.allCases.last!
        for race in races {
            challenges = challenges.clamped(to: race.challengeRange())
        }
        return challenges
    }
    
    static private func defensiveChallenge(hitPoints: Int, armorClass: Int) -> Challenge? {
        guard var base = Challenge(hitPoints: hitPoints) else { return nil }
        if base.armorClass.contains(armorClass) {
            return base
        } else {
            let median = base.armorClass.median()
            let difference = (median - armorClass) / 2
            if difference > 0 {
                for _ in 0...difference {
                    base.next()
                }
            } else {
                for _ in difference...0 {
                    base.previous()
                }
            }
            return base
        }
    }
    
    static private func offensiveChallenge(attackBonus: Int, damagePerRound: Int) -> Challenge? {
        guard var base = Challenge(damagePerRound: damagePerRound) else { return nil }
        if base.attackBonus.contains(attackBonus) {
            return base
        } else {
            let median = base.armorClass.median()
            let difference = (median - attackBonus) / 2
            if difference > 0 {
                for _ in 0...difference {
                    base.next()
                }
            } else {
                for _ in difference...0 {
                    base.previous()
                }
            }
            return base
        }
    }
}

extension Array where Element == Challenge {
    func sorted() -> [Challenge] {
        return self.sorted { (challenge1, challenge2) -> Bool in
            return challenge1 <= challenge2
        }
    }
}
