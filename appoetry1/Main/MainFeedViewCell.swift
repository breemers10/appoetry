//
//  MainFeedViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class MainFeedViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var poemLabel: UILabel!
    @IBOutlet weak var editPostButton: UIButton!
    
    var onFavourite: (() -> Void)?
    
    private var postID: String!
    var viewModel: MainViewModel?
    private var isFavorited = false

    private let favoriteImage = UIImage.favorite
    private let unfavoriteImage = UIImage.unfavorite
    
    func configure(post: Post) {
        guard let imageUrl = post.pathToImage else { return }
        guard let url = URL(string: imageUrl) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        poemLabel.text = post.poem
        favoritesLabel.text = "\(post.favorites!.formatUsingAbbrevation()) Favorites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        poemLabel.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        let favourited = post.peopleFavorited.contains(DatabaseService.instance.currentUserID!)
        isFavorited = favourited
        if isFavorited {
            favoriteButton.setImage(favoriteImage, for: UIControl.State.normal)
        } else {
            favoriteButton.setImage(unfavoriteImage, for: UIControl.State.normal)
        }
    }
    
    func enableButton() {
        editPostButton.isHidden = false
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
    
    @IBAction private func favoriteBttnPressed(_ sender: Any) {
//        onFavourite?()
        isFavorited ? unfavoritePost() : favoritePost()
    }
}
