//
//  Array Extension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/14/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    /// Removes duplicate items within an Array
    /// - returns: An Array where the duplicates contained within have been removed
    func removingDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        return result
    }
    
    /// Removes duplicate items within an Array
    /// - returns: An Array where the duplicates contained within have been removed
    mutating func removingDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
    
    func removingExisting(_ existing: [Element]) -> [Element] {
        var result = [Element]()
        for value in self {
            if !existing.contains(value) {
                result.append(value)
            }
        }
        return result
    }
}
