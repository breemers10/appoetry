//
//  ProfilesFeedCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 20.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class ProfilesFeedCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var viewStripe: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var unfavoriteButton: UIButton!
    @IBOutlet weak var poemLabel: UILabel!
    
    var postID: String!
    var viewModel: ProfilesViewModel?
    
    func configure(post: Post) {
        guard let url = URL(string: post.pathToImage!) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        poemLabel.text = post.poem
        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
        let readmoreFontColor = UIColor.blue
        self.poemLabel.addTrailing(with: "... ", moreText: "Read whole post", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
        favoritesLabel.text = "\(post.favorites!.formatUsingAbbrevation()) Favorites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        
        for person in post.peopleFavorited {
            if person == DatabaseService.instance.currentUserID {
                favoriteButton.isHidden = true
                unfavoriteButton.isHidden = false
                break
            }
        }
    }
    
    @IBAction private func favoriteButtonPressed(_ sender: Any) {
        favoriteButton.isHidden = false
        
        viewModel?.favoritePost(postID: postID, with: { (favorited) in
            if !favorited {
                self.favoritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favorites"
                
                self.favoriteButton.isHidden = true
                self.unfavoriteButton.isHidden = false
                self.favoriteButton.isEnabled = true
            }
        })
    }
    
    @IBAction private func unfavoriteButtonPressed(_ sender: Any) {
        unfavoriteButton.isEnabled = false
        
        viewModel?.unfavoritePost(postID: postID, with: { (unfavorited) in
            if !unfavorited {
                self.favoritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favorites"
                self.favoriteButton.isHidden = false
                self.unfavoriteButton.isHidden = true
                self.unfavoriteButton.isEnabled = true
            }
        })
    }
}
