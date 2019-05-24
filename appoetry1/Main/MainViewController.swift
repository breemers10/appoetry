//
//  MainViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    var viewModel: MainViewModel?
    private let createPostButton = UIButton(type: .system)
    private let transparentButton = UIButton(type: .system)
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        fetchPosts()
        checkIfChanged()
        
        viewModel?.reloadAtIndex = { idx in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: idx, section: 0)])
            }
        }
        
        if let flowLayout = UICollectionViewLayout() as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let width = collectionView.frame.width - 20
            
            flowLayout.estimatedItemSize = CGSize(width: width, height: 300)
        }
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        viewModel?.getMainFeed(with: { [weak self] (fetched) in
            if fetched {
                self?.collectionView.reloadData()
            }
        })
    }
    
    func checkIfChanged() {
        viewModel?.checkIfChanged(with: { idx in
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: idx, section: 0)])
            }
        })
    }
    
    @objc func createPostButtonPressed(sender: UIButton) {
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
        navigationItem.titleView = imageView
        
        navigationItem.title = "Main"
    }
    
    @objc private func tapFunction(sender: UITapGestureRecognizer) {
        guard let postId = viewModel?.databaseService?.mainPosts[(sender.view?.tag)!].postID else { return }
        
        viewModel?.onPostTap?(postId)
    }
    
    @objc private func authorButtonPressed(button: UIButton) {
        let id = button.tag
        
        guard let userId = viewModel?.databaseService?.mainPosts[id].userID else { return }
        viewModel?.onAuthorTap?(userId)
    }
    
    @objc private func editPostButtonPressed(button: UIButton) {
        let id = button.tag
        
        guard let postId = viewModel?.databaseService?.mainPosts[id].postID else { return }
        viewModel?.onEditPostTap?(postId)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.databaseService?.mainPosts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath)
        
        if let myCell = cell as? MainFeedViewCell {
            myCell.onFavourite = { [weak self] in
                self?.viewModel?.toggleFavourite(at: indexPath.row)
            }
            
            if let post = viewModel?.databaseService?.mainPosts[indexPath.row] {
                myCell.configure(post: post)
                myCell.viewModel = viewModel
                
                myCell.authorButton.tag = indexPath.row
                myCell.authorButton.addTarget(self, action: #selector(authorButtonPressed), for: .touchUpInside)
                
                if viewModel?.databaseService?.mainPosts[indexPath.row].userID == viewModel?.checkIfCurrentUser() {
                    myCell.enableButton()
                    myCell.editPostButton.tag = indexPath.row
                    myCell.editPostButton.addTarget(self, action: #selector(editPostButtonPressed), for: .touchUpInside)
                }
                
                myCell.poemLabel.tag = indexPath.row
                myCell.poemLabel.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
                myCell.poemLabel.addGestureRecognizer(tap)
            }
        }
        return cell
    }
}
