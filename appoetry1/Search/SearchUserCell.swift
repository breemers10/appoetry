//
//  SearchUserCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 13.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Kingfisher

class SearchUserCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    func configure(indexPath: Int) {
        guard let url = URL(string: MySharedInstance.instance.userInfo[indexPath].imageUrl!) else { return }
        userImage.kf.setImage(with: url)
        usernameLabel.text = MySharedInstance.instance.userInfo[indexPath].username
        fullNameLabel.text = MySharedInstance.instance.userInfo[indexPath].fullName
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
}
