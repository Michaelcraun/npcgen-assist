//
//  UILabelExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 3/6/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import UIKit

extension UILabel {
    func calculateSize(estimatedHeight height: CGFloat? = nil, estimatedWidth width: CGFloat? = nil) -> CGSize {
        let maxSize = CGSize(width: width ?? .infinity, height: height ?? .infinity)
        return self.sizeThatFits(maxSize)
    }
}
