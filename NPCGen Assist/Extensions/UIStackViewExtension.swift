//
//  UIStackViewExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 2/23/20.
//  Copyright © 2020 Craunic Productions. All rights reserved.
//

import UIKit

extension UIStackView {
    func addBackground(color: UIColor, cornerRadius: CGFloat = 10) {
        let subview = UIView(frame: bounds)
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subview.backgroundColor = color
        subview.layer.cornerRadius = cornerRadius
        insertSubview(subview, at: 0)
    }
}
