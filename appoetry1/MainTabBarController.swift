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
       
        tabBar.barTintColor = UIColor(displayP3Red: 38/255, green: 196/255, blue: 133/255, alpha: 1)
        
         setPosition()
    }
    
    func setPosition() {
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
}
