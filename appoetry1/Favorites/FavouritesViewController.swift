//
//  FavouritesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class FavouritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: FavouritesViewModel?
    let createPostButton = UIButton(type: .system)
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [Post]()
    var favouritedPosts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        fetchPosts()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        AppDelegate.instance().showActivityIndicator()
        
        let uid = Auth.auth().currentUser?.uid
        
        MySharedInstance.instance.ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let snap = snapshot.value as! [String : AnyObject]
            
            if let favouritedPosts = snap["favouritedPosts"] as? [String : String] {
                for (_,user) in favouritedPosts {
                    self.favouritedPosts.append(user)
                }
            }
            
            self.favouritedPosts.append(uid!)
            AppDelegate.instance().dismissActivityIndicator()
        })
        
        MySharedInstance.instance.ref.child("posts").observeSingleEvent(of: .value, with: { (snap) in
            let postSnap = snap.value as! [String: AnyObject]
            
            for (_,post) in postSnap {
                if
                    let userID = post["userID"] as? String,
                    let postID = post["postID"] as? String {
                    for each in self.favouritedPosts {
                        if each == postID {
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouritePostCell", for: indexPath) as! FavouriteFeedViewCell
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

extension FavouritesViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
