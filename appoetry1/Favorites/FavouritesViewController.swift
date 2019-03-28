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
        return (viewModel?.databaseService?.favouritePosts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouritePostCell", for: indexPath)

        if let myCell = cell as? FavouriteFeedViewCell {
            if let post = viewModel?.databaseService?.favouritePosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
                myCell.authorButton.isUserInteractionEnabled = true
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelPressed))
                myCell.authorButton.addGestureRecognizer(gestureRecognizer)
            }
        }
        return cell
    }
    
    @objc func labelPressed(){
        viewModel?.onAuthorTap?((viewModel?.databaseService?.idx)!)
    }
}

extension FavouritesViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
