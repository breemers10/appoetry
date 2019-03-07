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
        setupNavigationBarItems()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Main feed"
    }
    
    private func setupNavigationBarItems() {
        
        let createPostButton = UIButton(type: .system)
        createPostButton.setImage(UIImage(named: "create_new")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

