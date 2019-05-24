//
//  FavoritesViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    var viewModel: FavoritesViewModel?
    private let createPostButton = UIButton(type: .system)
    private let transparentButton = UIButton(type: .system)
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        fetchPosts()
        viewModel?.checkIfChanged(with: { idx in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: idx, section: 0)])
            }
        })

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        viewModel?.checkIfAdded(with: { [weak self] (fetched) in
            if fetched {
                self?.collectionView.reloadData()
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
        
        createPostButton.setImage(UIImage.create_new?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        transparentButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: transparentButton)
        
        let imageView = UIImageView(image: UIImage.logo)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        navigationItem.title = "Favorites"
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc private func authorButtonPressed(button: UIButton) {
        let id = button.tag
        
        guard let userId = viewModel?.databaseService?.favoritePosts[id].userID else { return }
        viewModel?.onAuthorTap?(userId)
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        guard let postId = viewModel?.databaseService?.favoritePosts[(sender.view?.tag)!].postID else { return }
        
        viewModel?.onPostTap?(postId)
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.databaseService?.favoritePosts.count ?? 0
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
                
                myCell.poemLabel.tag = indexPath.row
                myCell.poemLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
                myCell.poemLabel.addGestureRecognizer(tap)
                
                myCell.unfavorite = { [weak self] in
                    self?.viewModel?.unfavoritePost(postID: (self?.viewModel?.databaseService?.favoritePosts[indexPath.row].postID)!, with: { [weak self] (unfavorited) in
                        if unfavorited {
                            self?.collectionView.reloadData()
                        }
                    })
                }
            }
        }
        return cell
    }
}
