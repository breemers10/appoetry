//
//  MainFeedViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class MainFeedViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var authorButton: UIButton!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    
    var postID: String!
    var viewModel: MainViewModel?
    
    func configure(post: Post) {
        guard let url = URL(string: post.pathToImage!) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        postTextView.text = post.poem
        postTextView.isEditable = false
        favouritesLabel.text = "\(post.favourites!) Favourites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        textViewHC.constant = postTextView.contentSize.height
        
        for person in post.peopleFavourited {
            if person == Auth.auth().currentUser!.uid {
                favouriteButton.isHidden = true
                unfavouriteButton.isHidden = false
                break
            }
        }
    }
    
    @IBAction func favouriteBttnPressed(_ sender: Any) {
        self.favouriteButton.isHidden = false
        
        viewModel?.favouritePost(postID: postID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            if (self.viewModel?.databaseService?.favourited)! {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                
                self.favouriteButton.isHidden = true
                self.unfavouriteButton.isHidden = false
                self.favouriteButton.isEnabled = true
            }
        }
    }
    @IBAction func unfavouriteBttnPressed(_ sender: Any) {
        self.unfavouriteButton.isEnabled = false
        viewModel?.unfavouritePost(postID: postID)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if (self.viewModel?.databaseService?.unfavourited)! {
                self.favouritesLabel.text = "\((self.viewModel?.databaseService?.count)!) Favourites"
                self.favouriteButton.isHidden = false
                self.unfavouriteButton.isHidden = true
                self.unfavouriteButton.isEnabled = true
            }
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutSubviews()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}
