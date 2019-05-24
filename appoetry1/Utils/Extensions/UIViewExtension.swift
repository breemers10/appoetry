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

        gradient.colors = [UIColor(displayP3Red: 228/255, green: 239/255, blue: 233/255, alpha: 1).cgColor,
                           UIColor(displayP3Red: 147/255, green: 165/255, blue: 207/255, alpha: 1).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
