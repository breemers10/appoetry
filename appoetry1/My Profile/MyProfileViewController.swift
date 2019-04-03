//
//  MyProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase


class MyProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: MyProfileViewModel?
    @IBOutlet weak var collectionView: UICollectionView!
    let editProfileButton = UIButton(type: .system)
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
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        addingTargetToSignOut()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profilePicture.isUserInteractionEnabled = true
        
        fetchUserInfo()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func fetchUserInfo() {
        viewModel?.getUserInfo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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
            self.profilePicture.kf.setImage(with: url)
        }
    }
    
    private func fetchPosts() {
        viewModel?.getMyProfilePosts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.collectionView.reloadData()
        }
    }
    
    @objc private func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePicture.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func editProfileButtonPressed(sender: UIButton) {
        viewModel?.toEditProfile()
    }
    
    private func addingTargetToCreatePostVC() {
        editProfileButton.addTarget(self, action: #selector(self.editProfileButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc private func signOutButtonPressed(sender: UIButton) {
        viewModel?.signOut()
    }
    
    private func addingTargetToSignOut() {
        signOutButton.addTarget(self, action: #selector(self.signOutButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setupNavigationBarItems() {
        editProfileButton.setTitle("Edit profile", for: .normal)
        editProfileButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editProfileButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: signOutButton)
        
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
