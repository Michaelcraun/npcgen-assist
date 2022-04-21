//
//  UITableViewCellExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/22/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UITableViewCell {
    /// Clears the cell of all contents.
    func clearCell() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
}
