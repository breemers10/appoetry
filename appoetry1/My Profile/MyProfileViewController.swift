//
//  MyProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class MyProfileViewController: UIViewController {
    
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
    @IBOutlet private weak var followerButton: UIButton!
    @IBOutlet private weak var followingButton: UIButton!
    @IBOutlet private weak var profilePicture: UIImageView!
    
    var viewModel: MyProfileViewModel?
    private let signOutButton = UIButton(type: .system)
    private let transparentButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        addingTargetToSignOut()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        
        checkIfChanged()
        fetchUserInfo()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchUserInfo() {
        viewModel?.getUserInfo(with: { [weak self] (fetched) in
            if fetched {
                guard let userInfo = self?.viewModel?.databaseService?.userInfo else { return }
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
                
                guard let imageUrl = userInfo.imageUrl else { return }
                let url = URL(string: imageUrl)
                self?.profilePicture.kf.setImage(with: url)
            }
        })
    }
    
    func checkIfChanged() {
        viewModel?.checkIfChanged(with: { idx in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: idx, section: 0)])
            }
        })
    }
    
    func fetchPosts() {
        viewModel?.getMyProfilePosts(with: { [weak self] (fetched) in
            if fetched {
                self?.collectionView.reloadData()
            }
        })
    }
    
    @IBAction private func editProfileButtonPressed(_ sender: UIButton) {
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
        
        transparentButton.frame = CGRect(x: 0, y: 0, width: 57, height: 34)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: signOutButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: transparentButton)
        
        let imageView = UIImageView(image: UIImage.logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        navigationItem.title = "My Profile"
    }
    
    @IBAction private func followerButtonPressed(_ sender: Any) {
        guard let idx = viewModel?.databaseService?.getCurrentUID() else { return }
        viewModel?.onFollowersButtonTap?(idx)
    }
    
    @IBAction private func followingButtonPressed(_ sender: Any) {
        guard let idx = viewModel?.databaseService?.getCurrentUID() else { return }
        viewModel?.onFollowingButtonTap?(idx)
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        guard let postId = viewModel?.databaseService?.myPosts[(sender.view?.tag)!].postID else { return }
        
        viewModel?.onPostTap?(postId)
    }
    
    @objc private func editPostButtonPressed(button: UIButton) {
        let id = button.tag
        
        guard let postId = viewModel?.databaseService?.myPosts[id].postID else { return }
        viewModel?.onEditPostTap?(postId)
    }
}

extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.databaseService?.myPosts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPostCell", for: indexPath)
        if let myCell = cell as? MyProfileFeedCell {
            if let post = viewModel?.databaseService?.myPosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
                
                myCell.editPostButton.tag = indexPath.row
                myCell.editPostButton.addTarget(self, action: #selector(editPostButtonPressed), for: .touchUpInside)
                
                myCell.poemLabel.tag = indexPath.row
                myCell.poemLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
                myCell.poemLabel.addGestureRecognizer(tap)
            }
        }
        return cell
    }
}
