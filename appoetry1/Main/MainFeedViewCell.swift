//
//  MainFeedViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 15.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainFeedViewCell: UICollectionViewCell {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var unfavouriteButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    
    @IBAction func favouriteBttnPressed(_ sender: Any) {
        
    }
    
    @IBAction func unfavouriteBttnPressed(_ sender: Any) {
        
    }
}
