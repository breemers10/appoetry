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
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            _ = snapshot.value as! [String : AnyObject]
            
            self.usersPosts.append(Auth.auth().currentUser!.uid)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if let userID = post["userID"] as? String {
                    for each in self.usersPosts {
                        if each == userID {
                            let posst = Post()
                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String, let genre = post["genre"] as? String {
                                posst.username = author
                                posst.favourites = favourites
                                posst.pathToImage = pathToImage
                                posst.postID = postID
                                posst.userID = userID
                                posst.poem = poem
                                posst.genre = genre
                                
                                if let people = post["peopleFavourited"] as? [String : AnyObject] {
                                    for (_,person) in people {
                                        posst.peopleFavourited.append(person as! String)
                                    }
                                }
                                self.posts.append(posst)
                            }
                        }
                    }
                    AppDelegate.instance().dismissActivityIndicator()
                    self.collectionView.reloadData()
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
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
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myPostCell", for: indexPath) as! MyProfileFeedCell
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.posts[indexPath.row].username
        cell.textView.text = self.posts[indexPath.row].poem
        cell.textView.isEditable = false
        cell.favouritesLabel.text = "\(self.posts[indexPath.row].favourites!) Favourites"
        cell.postID = self.posts[indexPath.row].postID
        cell.genreLabel.text = self.posts[indexPath.row].genre

        
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

extension MyProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
