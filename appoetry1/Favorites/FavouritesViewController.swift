//
//  FavouritesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favourites"
    }
}

extension FavouritesViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
