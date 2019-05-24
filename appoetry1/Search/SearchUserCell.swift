//
//  SearchUserCell.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 13.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import Kingfisher

final class SearchUserCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    
    func configure(userInfo: UserInfo) {
        guard let imageUrl = userInfo.imageUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        userImage.kf.setImage(with: url)
        usernameLabel.text = userInfo.username
        fullNameLabel.text = userInfo.fullName
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.clipsToBounds = true
    }
}
