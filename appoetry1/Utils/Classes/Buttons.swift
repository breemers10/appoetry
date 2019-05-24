//
//  loginButton.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class Buttons: UIButton {

    @IBInspectable var rounded: CGFloat = 0 { didSet {
        self.layer.cornerRadius = rounded
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 { didSet {
        self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}
