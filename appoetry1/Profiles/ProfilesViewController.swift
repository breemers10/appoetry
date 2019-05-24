//
//  ProfilesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 20.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class ProfilesViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var firstGenreLabel: UILabel!
    @IBOutlet private weak var secondGenreLabel: UILabel!
    @IBOutlet private weak var thirdGenreLabel: UILabel!
    @IBOutlet private weak var favoriteGenresLabel: UILabel!
    @IBOutlet private weak var firstNumberLabel: UILabel!
    @IBOutlet private weak var secondNumberLabel: UILabel!
    @IBOutlet private weak var thirdNumberLabel: UILabel!
    @IBOutlet private weak var profilePicture: UIImageView!
    @IBOutlet private weak var followButton: UIButton!
    @IBOutlet private weak var unfollowButton: UIButton!
    @IBOutlet private weak var followersButton: UIButton!
    @IBOutlet private weak var followingButton: UIButton!
    
    private let createPostButton = UIButton(type: .system)
    private let signOutButton = UIButton(type: .system)

    var viewModel: ProfilesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        fetchUsersInfo()
        fetchPosts()
        checkFollowing()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchUsersInfo() {
        viewModel?.getUserInfo(with: { [weak self] (fetched) in
            if fetched {
                guard let userInfo = self?.viewModel?.databaseService?.userInfo else { return }
                guard let imageUrl = userInfo.imageUrl else { return }
                let url = URL(string: imageUrl)
                
                self?.usernameLabel.text = userInfo.username
                self?.fullNameLabel.text = userInfo.fullName
                self?.emailLabel.text = userInfo.email
                self?.firstGenreLabel.text = userInfo.firstGenre
                self?.secondGenreLabel.text = userInfo.secondGenre
                self?.thirdGenreLabel.text = userInfo.thirdGenre
                self?.favoriteGenresLabel.text = "Favorite genres:"
                self?.firstNumberLabel.text = "1."
                self?.secondNumberLabel.text = "2."
                self?.thirdNumberLabel.text = "3."
                self?.profilePicture.kf.setImage(with: url)
                
                if userInfo.userID == self?.viewModel?.checkIfCurrentUser() {
                    self?.followButton.isHidden = true
                    self?.unfollowButton.isHidden = true
                }
            }
        })
    }
    
    private func fetchPosts() {
        viewModel?.getProfilesFeed(with: { [weak self] (fetched) in
            if fetched {
                self?.collectionView.reloadData()
            }
        })
    }
    
    @IBAction private func followButtonPressed(_ sender: Any) {
        viewModel?.followUser(with: { [weak self] (hasFollowed) in
            if hasFollowed {
                self?.followButton.isHidden = true
                self?.unfollowButton.isHidden = false
                self?.followButton.isEnabled = true
            }
        })
    }
    
    @IBAction private func unfollowButtonPressed(_ sender: Any) {
        viewModel?.unfollowUser(with: { [weak self] (hasUnfollowed) in
            if hasUnfollowed {
                self?.unfollowButton.isHidden = true
                self?.followButton.isHidden = false
                self?.unfollowButton.isEnabled = true
            }
        })
    }
    
    private func checkFollowing() {
        viewModel?.checkFollowings(with: { [weak self] (isFollowed) in
            if isFollowed {
            self?.followButton.isHidden = true
            self?.unfollowButton.isHidden = false
            self?.followButton.isEnabled = true
            } else {
            self?.followButton.isHidden = false
            self?.unfollowButton.isHidden = true
            self?.unfollowButton.isEnabled = true
            }
        })
    }
    
    @IBAction private func followersButtonPressed(_ sender: Any) {
        viewModel?.onFollowersButtonTap?()
    }
    
    @IBAction private func followingButtonPressed(_ sender: Any) {
        viewModel?.onFollowingButtonTap?()
    }
    
    private func addingTargetToCreatePostVC() {
        createPostButton.addTarget(self, action: #selector(self.createPostButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc private func createPostButtonPressed(sender: UIButton) {
        viewModel?.createPost()
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        guard let postId = viewModel?.databaseService?.profilePosts[(sender.view?.tag)!].postID else { return }
        
        viewModel?.onPostTap?(postId)
    }
    
    private func setupNavigationBarItems() {
        
        createPostButton.setImage(UIImage.create_new?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        
        let imageView = UIImageView(image: UIImage.logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        navigationItem.title = "Profile"
    }
}

extension ProfilesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.databaseService?.profilePosts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilesPostCell", for: indexPath)
        if let myCell = cell as? ProfilesFeedCell {
            if let post = viewModel?.databaseService?.profilePosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
                
                myCell.poemLabel.tag = indexPath.row
                myCell.poemLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
                myCell.poemLabel.addGestureRecognizer(tap)
            }
        }
        return cell
    }
}
