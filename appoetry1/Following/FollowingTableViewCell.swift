//
//  FollowingTableViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FollowingTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    func configure(indexPath: Int) {
        guard let url = URL(string: MySharedInstance.instance.userInfo[indexPath].imageUrl!) else { return }

        usernameLabel.text = MySharedInstance.instance.userInfo[indexPath].username
        fullNameLabel.text = MySharedInstance.instance.userInfo[indexPath].fullName
        userImage.kf.setImage(with: url)
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
}
