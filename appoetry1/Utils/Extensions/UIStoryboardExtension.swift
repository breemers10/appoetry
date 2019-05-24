//
//  UIStoryboardExtension.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 16.05.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func getStoryboard(with name: StoryboardNames) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: Bundle.main)
    }
}
