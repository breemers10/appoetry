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
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPosts()
        
        if let flowLayout = UICollectionViewLayout() as? UICollectionViewFlowLayout,
            let collectionView = collectionView {
            let width = collectionView.frame.width - 20
            
            flowLayout.estimatedItemSize = CGSize(width: width, height: 300)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchPosts() {
        viewModel?.loadMainFeed()
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
        return (viewModel?.posts.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! MainFeedViewCell
        let url = URL(string: (viewModel?.posts[indexPath.row].pathToImage)!)
        
        cell.postImage.kf.setImage(with: url)
        cell.authorLabel.text = viewModel?.posts[indexPath.row].username
        cell.postTextView.text = viewModel?.posts[indexPath.row].poem
        cell.postTextView.isEditable = false
        cell.favouritesLabel.text = "\((viewModel?.posts[indexPath.row].favourites)!) Favourites"
        cell.postID = viewModel?.posts[indexPath.row].postID
        cell.genreLabel.text = viewModel?.posts[indexPath.row].genre
        cell.dateLabel.text = viewModel?.posts[indexPath.row].createdAt!.calendarTimeSinceNow()
        cell.textViewHC.constant = cell.postTextView.contentSize.height
        
        cell.authorButton.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelPressed))
        cell.authorButton.addGestureRecognizer(gestureRecognizer)
        
        for person in (viewModel?.posts[indexPath.row].peopleFavourited)! {
            if person == Auth.auth().currentUser!.uid {
                cell.favouriteButton.isHidden = true
                cell.unfavouriteButton.isHidden = false
                break
            }
        }
        return cell
    }
    @objc func labelPressed(){
        viewModel?.onAuthorTap?((viewModel?.idx)!)
    }
}

extension MainViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

