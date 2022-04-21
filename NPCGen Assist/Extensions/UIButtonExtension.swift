//
//  UIButtonExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 1/24/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

extension UIButton {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let ratio: CGFloat = self.bounds.width > 50 ? 1.025 : 1.1
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
}
