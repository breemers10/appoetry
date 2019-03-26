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
        viewModel?.getFavouritesPosts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.collectionView.reloadData()
        }
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
        return viewModel?.posts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouritePostCell", for: indexPath) as! FavouriteFeedViewCell
        let url = URL(string: (viewModel?.posts[indexPath.row].pathToImage)!)
        
        cell.postImage.kf.setImage(with: url)
        cell.authorLabel.text = viewModel?.posts[indexPath.row].username
        cell.textView.text = viewModel?.posts[indexPath.row].poem
        cell.textView.isEditable = false
        cell.favouritesLabel.text = "\((viewModel?.posts[indexPath.row].favourites)!) Favourites"
        cell.postID = viewModel?.posts[indexPath.row].postID
        cell.dateLabel.text = viewModel?.posts[indexPath.row].createdAt!.calendarTimeSinceNow()
        cell.genreLabel.text = viewModel?.posts[indexPath.row].genre
        cell.textViewHC.constant = cell.textView.contentSize.height
        
        for person in (viewModel?.posts[indexPath.row].peopleFavourited)! {
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
