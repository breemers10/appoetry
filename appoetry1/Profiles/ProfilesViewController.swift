//
//  ProfilesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 20.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class ProfilesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: ProfilesViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    let createPostButton = UIButton(type: .system)
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
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var unfollowButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        
        fetchPosts()
        checkFollowing()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            guard let url = URL(string: (self.viewModel?.imageUrl)!) else { return }
            
            self.usernameLabel.text = self.viewModel?.username
            self.fullNameLabel.text = self.viewModel?.fullName
            self.emailLabel.text = self.viewModel?.email
            self.firstGenreLabel.text = self.viewModel?.firstGenre
            self.secondGenreLabel.text = self.viewModel?.secondGenre
            self.thirdGenreLabel.text = self.viewModel?.thirdGenre
            self.favouriteGenresLabel.text = "Favourite genres:"
            self.firstNumberLabel.text = "1."
            self.secondNumberLabel.text = "2."
            self.thirdNumberLabel.text = "3."
            self.profilePicture.kf.setImage(with: url)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        viewModel?.getUsersProfile()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.collectionView.reloadData()
        }
    }
    
    @IBAction func followButtonPressed(_ sender: Any) {
        let key = MySharedInstance.instance.ref.child("users").childByAutoId().key
        let uid = Auth.auth().currentUser!.uid
        let following = ["following/\(key!)" : (viewModel?.idx)!]
        let followers = ["followers/\(key!)" : uid]
        
        MySharedInstance.instance.ref.child("users").child(uid).updateChildValues(following)
        MySharedInstance.instance.ref.child("users").child((viewModel?.idx)!).updateChildValues(followers)
        
        self.followButton.isHidden = true
        self.unfollowButton.isHidden = false
        self.followButton.isEnabled = true
    }
    
    @IBAction func unfollowButtonPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser!.uid
        MySharedInstance.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == (self.viewModel?.idx)! {
                        
                        MySharedInstance.instance.ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        MySharedInstance.instance.ref.child("users").child((self.viewModel?.idx)!).child("followers/\(ke)").removeValue()
                        self.unfollowButton.isHidden = true
                        self.followButton.isHidden = false
                        self.unfollowButton.isEnabled = true
                    }
                }
            }
        })
    }
    
    func checkFollowing() {
        let uid = Auth.auth().currentUser!.uid
        
        MySharedInstance.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == (self.viewModel?.idx)! {
                        self.followButton.isHidden = true
                        self.unfollowButton.isHidden = false
                        self.followButton.isEnabled = true
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    @IBAction func followersButtonPressed(_ sender: Any) {
        viewModel?.onFollowersButtonTap?()
    }
    
    @IBAction func followingButtonPressed(_ sender: Any) {
        viewModel?.onFollowingButtonTap?()
    }
    
    private func addingTargetToCreatePostVC() {
        createPostButton.addTarget(self, action: #selector(self.createPostButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func createPostButtonPressed(sender: UIButton) {
        viewModel?.createPost()
    }
    
    private func setupNavigationBarItems() {
        createPostButton.setImage(UIImage(named: "create_new")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        
        let titleTextAttributed: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85), .font: UIFont(name: "SnellRoundhand-Bold", size: 30) as Any]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributed
        navigationItem.title = "Appoetry"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModel?.databaseService?.profilesPosts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilesPostCell", for: indexPath)
        if let myCell = cell as? ProfilesFeedCell {
            if let post = viewModel?.databaseService?.profilesPosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
            }
        }
        return cell
    }
}

extension ProfilesViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
