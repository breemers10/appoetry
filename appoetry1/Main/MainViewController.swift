//
//  MainViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: MainViewModel?
    let createPostButton = UIButton(type: .system)
    var posts = [Post]()
    var following = [String]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        
        fetchPosts()
    }
    
    func fetchPosts() {
        
        MySharedInstance.instance.ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let users = snapshot.value as! [String : AnyObject]
            for (_,value) in users {
                if let uid = value["uid"] as? String {
                    if uid == Auth.auth().currentUser?.uid {
                        if let followingUsers = value["following"] as? [String : String] {
                            for (_,user) in followingUsers {
                                self.following.append(user)
                            }
                        }
                        self.following.append(Auth.auth().currentUser!.uid)
                        
                        MySharedInstance.instance.ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                            let postSnap = snap.value as! [String: AnyObject]
                            
                            for (_,post) in postSnap {
                                if let userID = post["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            let posst = Post()
                                            if let author = post["author"] as? String, let favourites = post["favourites"] as? Int, let pathToImage = post["pathToImage"] as? String, let postID = post["postID"] as? String, let poem = post["poem"] as? String {
                                                posst.username = author
                                                posst.favourites = favourites
                                                posst.pathToImage = pathToImage
                                                posst.postID = postID
                                                posst.userID = userID
                                                posst.poem = poem
                                                
                                                self.posts.append(posst)
                                            }
                                        }
                                    }
                                    self.collectionView.reloadData()
                                }
                            }
                        })
                    }
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! MainFeedViewCell
        
        cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.posts[indexPath.row].username
        cell.postTextView.text = self.posts[indexPath.row].poem
        cell.favouritesLabel.text = "\(String(describing:  self.posts[indexPath.row].favourites)) Favourites"
        
        return cell
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

