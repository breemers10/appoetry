//
//  MainViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
        
    @IBOutlet weak var welcomeLabel: UILabel!
    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

