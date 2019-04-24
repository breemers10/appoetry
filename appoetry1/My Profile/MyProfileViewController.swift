//
//  MyProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase


class MyProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: MyProfileViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    let signOutButton = UIButton(type: .system)
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstGenreLabel: UILabel!
    @IBOutlet weak var secondGenreLabel: UILabel!
    @IBOutlet weak var thirdGenreLabel: UILabel!
    @IBOutlet weak var favouriteGenresLabel: UILabel!
    @IBOutlet weak var firstNumberLabel: UILabel!
    @IBOutlet weak var secondNumberLabel: UILabel!
    @IBOutlet weak var thirdNumberLabel: UILabel!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        addingTargetToSignOut()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        fetchUserInfo()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchUserInfo() {
        viewModel?.getUserInfo(with: { (fetched) in
            if fetched {
                guard let userInfo = self.viewModel?.databaseService?.userInfo else { return }
                let url = URL(string: userInfo.imageUrl!)
                self.usernameLabel.text = userInfo.username
                self.fullNameLabel.text = userInfo.fullName
                self.emailLabel.text = userInfo.email
                self.firstGenreLabel.text = userInfo.firstGenre
                self.secondGenreLabel.text = userInfo.secondGenre
                self.thirdGenreLabel.text = userInfo.thirdGenre
                self.favouriteGenresLabel.text = "Favourite genres:"
                self.firstNumberLabel.text = "1."
                self.secondNumberLabel.text = "2."
                self.thirdNumberLabel.text = "3."
                self.profilePicture.kf.setImage(with: url)            }
        })
    }
    
    private func fetchPosts() {
        viewModel?.getMyProfilePosts(with: { (fetched) in
            if fetched {
                self.collectionView.reloadData()
            }
        })
    }
    
    @IBAction func editProfileButtonPressed(_ sender: UIButton) {
        viewModel?.toEditProfile()
    }

    @objc private func signOutButtonPressed(sender: UIButton) {
        viewModel?.signOut()
    }
    
    private func addingTargetToSignOut() {
        signOutButton.addTarget(self, action: #selector(self.signOutButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setupNavigationBarItems() {
 
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
        
        let titleTextAttributed: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85), .font: UIFont(name: "SnellRoundhand-Bold", size: 30) as Any]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributed
        navigationItem.title = "Appoetry"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.databaseService?.myProfilePosts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPostCell", for: indexPath)
        if let myCell = cell as? MyProfileFeedCell {
            if let post = viewModel?.databaseService?.myProfilePosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
            }
        }
        return cell
    }
    
    @IBAction private func followerButtonPressed(_ sender: Any) {
        viewModel?.onFollowersButtonTap?((viewModel?.databaseService?.idx)!)
    }
    
    @IBAction private func followingButtonPressed(_ sender: Any) {
        viewModel?.onFollowingButtonTap?((viewModel?.databaseService?.idx)!)
    }
}

extension MyProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
