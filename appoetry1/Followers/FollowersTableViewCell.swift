//
//  FollowersTableViewCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class FollowersTableViewCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!

    func configure(userInfo: UserInfo) {
        guard let imageUrl = userInfo.imageUrl else { return }
        guard let url = URL(string:
            imageUrl) else { return }

        usernameLabel.text = userInfo.username
        fullNameLabel.text = userInfo.fullName
        userImage.kf.setImage(with: url)
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
}
