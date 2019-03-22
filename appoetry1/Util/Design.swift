//
//  Design.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(displayP3Red: 227/255, green: 253/255, blue: 245/255, alpha: 1).cgColor,
                           UIColor(displayP3Red: 255/255, green: 230/255, blue: 250/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIButton {
    func applyButtonDesign() {
        let buttonLayer = CALayer()
        buttonLayer.borderWidth = 3
        buttonLayer.borderColor = UIColor.lightGray.cgColor
        buttonLayer.cornerRadius = 5
    }
}

