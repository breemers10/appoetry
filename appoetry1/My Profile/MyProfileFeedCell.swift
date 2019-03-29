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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var viewStripe: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    
    var postID: String!
    var viewModel: MyProfileViewModel?
    
    func configure(post: Post) {
        guard let url = URL(string: post.pathToImage!) else { return }
        
        postImage.kf.setImage(with: url)
        authorLabel.text = post.username
        textView.text = post.poem
        textView.isEditable = false
        favouritesLabel.text = "\(post.favourites!) Favourites"
        postID = post.postID
        genreLabel.text = post.genre
        dateLabel.text = post.createdAt!.calendarTimeSinceNow()
        textViewHC.constant = textView.contentSize.height
        
        for person in post.peopleFavourited {
            if person == Auth.auth().currentUser!.uid {
                favouriteButton.isHidden = true
                unfavouriteButton.isHidden = false
                break
            }
        }
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
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
    
    @IBAction func unfavouriteButtonPressed(_ sender: Any) {
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
}
