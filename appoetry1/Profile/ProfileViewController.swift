//
//  ProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel?
    let createPostButton = UIButton(type: .system)
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstGenreLabel: UILabel!
    @IBOutlet weak var secondGenreLabel: UILabel!
    @IBOutlet weak var thirdGenreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.usernameLabel.text = self.viewModel?.username
            self.fullNameLabel.text = self.viewModel?.fullName
            self.emailLabel.text = self.viewModel?.email
            self.firstGenreLabel.text = self.viewModel?.firstGenre
            self.secondGenreLabel.text = self.viewModel?.secondGenre
            self.thirdGenreLabel.text = self.viewModel?.thirdGenre
        }
    }
    
    @objc func createPostButtonPressed(sender: UIButton) {
        viewModel?.createPost()
    }
    
    private func addingTargetToCreatePostVC() {
        createPostButton.addTarget(self, action: #selector(self.createPostButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setupNavigationBarItems() {
                
        createPostButton.setImage(UIImage(named: "create_new")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        
        let titleTextAttributed: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85), .font: UIFont(name: "SnellRoundhand-Bold", size: 30) as Any]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributed
        navigationItem.title = "Appoetry"
        
    }
}

extension ProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
