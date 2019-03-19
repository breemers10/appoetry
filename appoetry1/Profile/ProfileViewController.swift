//
//  ProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: ProfileViewModel?
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
    
    let picker = UIImagePickerController()
    var posts = [Post]()
    
    var usersPosts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        addingTargetToSignOut()
        
        fetchPosts()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profilePicture.isUserInteractionEnabled = true
  
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
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
            self.profilePicture.downloadImage(from: self.viewModel?.imageUrl)
        }
    }
    
    func fetchPosts() {
        viewModel?.databaseService.fetchProfilePosts()
        
        self.posts = (viewModel?.databaseService.posts)!
        self.usersPosts = (viewModel?.databaseService.usersPosts)!
        
        self.collectionView.reloadData()

    }
    @objc func handleSelectProfileImageView() {
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
 
    @objc func createPostButtonPressed(sender: UIButton) {
        viewModel?.createPost()
    }
    
    private func addingTargetToCreatePostVC() {
        createPostButton.addTarget(self, action: #selector(self.createPostButtonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func signOutButtonPressed(sender: UIButton) {
        viewModel?.signOut()
    }
    
    private func addingTargetToSignOut() {
        signOutButton.addTarget(self, action: #selector(self.signOutButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setupNavigationBarItems() {
        createPostButton.setImage(UIImage(named: "create_new")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        signOutButton.setTitle("Sign out", for: .normal)
        signOutButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: signOutButton)
        
        let titleTextAttributed: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85), .font: UIFont(name: "SnellRoundhand-Bold", size: 30) as Any]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributed
        navigationItem.title = "Appoetry"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.viewModel?.databaseService.posts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPostCell", for: indexPath) as! MyProfileFeedCell
        cell.postImage.downloadImage(from: self.viewModel?.databaseService.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.viewModel?.databaseService.posts[indexPath.row].username
        cell.textView.text = self.viewModel?.databaseService.posts[indexPath.row].poem
        cell.textView.isEditable = false
        cell.favouritesLabel.text = "\((self.viewModel?.databaseService.posts[indexPath.row].favourites)!) Favourites"
        cell.postID = self.viewModel?.databaseService.posts[indexPath.row].postID
        cell.genreLabel.text = self.viewModel?.databaseService.posts[indexPath.row].genre

        
        for person in self.posts[indexPath.row].peopleFavourited {
            if person == Auth.auth().currentUser!.uid {
                cell.favouriteButton.isHidden = true
                cell.unfavouriteButton.isHidden = false
                break
            }
        }
        return cell
    }
}

extension ProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
