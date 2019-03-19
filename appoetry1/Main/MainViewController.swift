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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPosts()
    }
    
    
    func fetchPosts() {
        viewModel?.databaseService.fetchFollowingPosts()
        
        self.following = (viewModel?.databaseService.following)!
        self.posts = (viewModel?.databaseService.posts)!
        
        self.collectionView.reloadData()

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
        return (self.viewModel?.databaseService.posts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! MainFeedViewCell
//        let url = URL(string: (self.viewModel?.databaseService.posts[indexPath.row].pathToImage)!)
        
        cell.postImage.downloadImage(from: self.viewModel?.databaseService.posts[indexPath.row].pathToImage)
        cell.authorLabel.text = self.viewModel?.databaseService.posts[indexPath.row].username
        cell.postTextView.text = self.viewModel?.databaseService.posts[indexPath.row].poem
        cell.postTextView.isEditable = false
        cell.favouritesLabel.text = "\((self.viewModel?.databaseService.posts[indexPath.row].favourites)!) Favourites"
        cell.postID = self.viewModel?.databaseService.posts[indexPath.row].postID
        cell.genreLabel.text = self.viewModel?.databaseService.posts[indexPath.row].genre
        
        for person in (self.viewModel?.databaseService.posts[indexPath.row].peopleFavourited)! {
            if person == Auth.auth().currentUser!.uid {
                cell.favouriteButton.isHidden = true
                cell.unfavouriteButton.isHidden = false
                break
            }
        }
        return cell
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

