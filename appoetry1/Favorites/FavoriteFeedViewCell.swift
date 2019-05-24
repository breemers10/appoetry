//
//  FavoriteFeedViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 18.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class FavoriteFeedViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var unfavoriteButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var poemLabel: UILabel!
    
    var viewModel: FavoritesViewModel?
    private var postID: String!
    var unfavorite: (() -> Void)?

    func configure(post: Post) {
        guard let imageUrl = post.pathToImage else { return }
        guard let url = URL(string: imageUrl) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        poemLabel.text = post.poem
        
        poemLabel.roundCorners([.bottomLeft, .bottomRight], radius: 5)
        
        favoritesLabel.text = "\(post.favorites!.formatUsingAbbrevation()) Favorites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
    }
    
    @IBAction private func unfavoriteButtonPressed(_ sender: Any) {
        viewModel?.onUnfavoriteButtonTap?()
        unfavorite?()
    }
}
