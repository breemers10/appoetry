//
//  MyProfileFeedCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 18.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MyProfileFeedCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var viewStripe: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var poemLabel: UILabel!
    
    var postID: String!
    var viewModel: MyProfileViewModel?
    
    func configure(post: Post) {
        guard let url = URL(string: post.pathToImage!) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        poemLabel.text = post.poem
        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 11.0)
        let readmoreFontColor = UIColor.blue
        self.poemLabel.addTrailing(with: "... ", moreText: "Read whole post", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
        favouritesLabel.text = "\(post.favourites!.formatUsingAbbrevation()) Favourites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        
        for person in post.peopleFavourited {
            if person == DatabaseService.instance.currentUserID {
                favouriteButton.isHidden = true
                unfavouriteButton.isHidden = false
                break
            }
        }
    }
    
    @IBAction private func favouriteButtonPressed(_ sender: UIButton) {
        favouriteButton.isHidden = false
        viewModel?.favouritePost(postID: postID, with: { (favorited) in
            if !favorited {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                
                self.favouriteButton.isHidden = true
                self.unfavouriteButton.isHidden = false
                self.favouriteButton.isEnabled = true
            }
        })
    }
    
    @IBAction private func unfavouriteButtonPressed(_ sender: UIButton) {
        unfavouriteButton.isEnabled = false
        viewModel?.unfavouritePost(postID: postID, with: { (unfavorited) in
            if !unfavorited {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                self.favouriteButton.isHidden = false
                self.unfavouriteButton.isHidden = true
                self.unfavouriteButton.isEnabled = true
            }
        })
    }
}
