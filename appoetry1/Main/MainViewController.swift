//
//  MainViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Main feed"
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

