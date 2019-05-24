//
//  MyProfileFeedCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 18.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class MyProfileFeedCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var viewStripe: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var poemLabel: UILabel!
    @IBOutlet weak var editPostButton: UIButton!
    
    private var postID: String!
    var viewModel: MyProfileViewModel?
    
    private var isFavorited = false
    private let favoriteImage = UIImage.favorite
    private let unfavoriteImage = UIImage.unfavorite
    
    func configure(post: Post) {
        guard let url = URL(string: post.pathToImage!) else { return }
        guard let uid = DatabaseService.instance.currentUserID else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        poemLabel.text = post.poem
        poemLabel.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        favoritesLabel.text = "\(post.favorites!.formatUsingAbbrevation()) Favorites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        
        let favourited = post.peopleFavorited.contains(uid)
        isFavorited = favourited
        if isFavorited {
            favoriteButton.setImage(favoriteImage, for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(unfavoriteImage, for: UIControl.State.normal)
        }
    }
    
    func favoritePost() {
        viewModel?.favoritePost(postID: postID, with: { [weak self] (favorited) in
            if favorited {
                self?.isFavorited = true
                guard let count = self?.viewModel?.databaseService?.count else { return }
                self?.favoritesLabel.text = "\(count) Favorites"
                self?.favoriteButton.setImage(self?.favoriteImage, for: UIControl.State.normal)
                
            }
        })
    }
    
    func unfavoritePost() {
        viewModel?.unfavoritePost(postID: postID, with: { [weak self] (unfavorited) in
            if unfavorited {
                self?.isFavorited = false
                guard let count = self?.viewModel?.databaseService?.count else { return }
                self?.favoritesLabel.text = "\(count) Favorites"
                self?.favoriteButton.setImage(self?.unfavoriteImage, for: UIControl.State.normal)
            }
        })
    }
    
    @IBAction private func favoriteButtonPressed(_ sender: UIButton) {
        isFavorited ? unfavoritePost() : favoritePost()
    }
}
