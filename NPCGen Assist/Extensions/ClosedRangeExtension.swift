//
//  ClosedRangeExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 9/14/19.
//  Copyright © 2019 Craunic Productions. All rights reserved.
//

import Foundation

extension ClosedRange where Bound == Int {
    func median() -> Bound {
        var array = Array(self)
        repeat {
            array.removeFirst()
            array.removeLast()
        } while array.count > 2
        return array.first!
    }
}
