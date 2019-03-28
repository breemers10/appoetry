//
//  FollowersTableViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!

    func configure(indexPath: Int) {
        guard let url = URL(string: DatabaseService.instance.userInfoArr[indexPath].imageUrl!) else { return }

        usernameLabel.text = DatabaseService.instance.userInfoArr[indexPath].username
        fullNameLabel.text = DatabaseService.instance.userInfoArr[indexPath].fullName
        userImage.kf.setImage(with: url)
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
}
