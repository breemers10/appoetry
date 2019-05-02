//
//  FavoritesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: FavoritesViewModel?
    let createPostButton = UIButton(type: .system)
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        fetchPosts()
        viewModel?.checkIfChanged(with: { (isChanged) in
            if isChanged {
                 self.collectionView.reloadData()
            }
        })

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        viewModel?.checkIfAdded(with: { (fetched) in
            if fetched {
                self.collectionView.reloadData()
            }
        })
    }
    
    @objc private func createPostButtonPressed(sender: UIButton) {
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
        return (viewModel?.databaseService?.favoritePosts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoritePostCell", for: indexPath)
        
        if let myCell = cell as? FavoriteFeedViewCell {
            if let post = viewModel?.databaseService?.favoritePosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
                myCell.authorButton.isUserInteractionEnabled = true
                myCell.authorButton.tag = indexPath.row
                myCell.authorButton.addTarget(self, action: #selector(authorButtonPressed), for: .touchUpInside)
                
                myCell.unfavorite = {
                    self.viewModel?.unfavoritePost(postID: (self.viewModel?.databaseService?.favoritePosts[indexPath.row].postID)!, with: { (unfavorited) in
                        if unfavorited {
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
        return cell
    }
    
    @objc private func authorButtonPressed(button: UIButton) {
        let id = button.tag
        
        guard let userId = viewModel?.databaseService?.favoritePosts[id].userID else { return }
        viewModel?.onAuthorTap?(userId)
    }
}

extension FavoritesViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
