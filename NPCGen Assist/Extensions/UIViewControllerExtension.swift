//
//  UIViewControllerExtension.swift
//  NPCGen5e
//
//  Created by Michael Craun on 1/24/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit

// MARK: - Keyboard control
extension UIViewController {
    func addKeyboardAdjustability() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Dismisses keyboard when the user taps anything but the keyboard.
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showNormalAlert(title: String, message: String, completionOK: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completionOK))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {  }
    @objc func keyboardWillHide(_ notification: NSNotification) {  }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - User interface and layout
extension UIViewController {
    /// <#Description#>
    var backButtonItem: UIBarButtonItem {
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.anchor(size: .init(width: 30, height: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return UIBarButtonItem(customView: button)
    }
    
    /// <#Description#>
    var idiom: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
    /// <#Description#>
    var screen: CGRect {
        return UIScreen.main.bounds
    }
    
    /// <#Description#>
    /// - Parameter text: <#text description#>
    static func attributedPlaceholder(with text: String) -> NSAttributedString {
        let placeholderAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.lightGray]
        return NSAttributedString(string: text, attributes: placeholderAttributes)
    }
    
    /// Presents a loading view with a dimmed view and a loading indicator in the center
    /// - parameter shouldShow: A Bool value indicating whether the loading view should be displayed or removed from the superview
    func presentLoadingView(_ shouldShow: Bool) {
        var fadeView: UIView?
        
        if shouldShow == true {
            fadeView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            fadeView?.backgroundColor = .black
            fadeView?.alpha = 0
            fadeView?.tag = 5050
            
            let spinner = UIActivityIndicatorView()
            spinner.color = .white
            spinner.style = .whiteLarge
            spinner.center = view.center
            
            view.addSubview(fadeView!)
            fadeView?.addSubview(spinner)
            
            spinner.startAnimating()
            fadeView?.fadeAlphaTo(0.7, withDuration: 0.2)
        } else {
            DispatchQueue.main.async {
                for subview in self.view.subviews {
                    if subview.tag == 5050 {
                        subview.fadeAlphaOut()
                    }
                }
            }
        }
    }
    
    /// Adds the background image to the view controller. Should be called in the layout function of the VC.
    func layoutBackground() {
        let bgImage = UIImageView()
        bgImage.clipsToBounds = true
        bgImage.contentMode = .scaleAspectFill
        bgImage.image = UIImage(named: "bg")
        bgImage.fillTo(view)
    }
}
