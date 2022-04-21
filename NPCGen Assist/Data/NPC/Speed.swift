//
//  Speed.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/30/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import Foundation

// MARK: - For use in a future update
struct Speed: Codable {
    private var burrow: Int?
    private var climb: Int?
    private var fly: Int?
    private var land: Int?
    private var swim: Int?
    
    var description: String {
        return ""
    }
}
