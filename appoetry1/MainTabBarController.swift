//
//  MainTabBarController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPosition()
        
        tabBar.tintColor = UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85)
    }
    
    func setPosition() {
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
