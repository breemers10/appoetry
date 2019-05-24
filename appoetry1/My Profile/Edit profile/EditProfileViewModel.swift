//
//  EditProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class EditProfileViewModel: NSObject {
    
    var onEditProfileCompletion: (() -> Void)?
    var onDeleteButtonPressed: (() -> Void)?
    var realGenre: Genres?
    
    var username: String?
    var email: String?
    var fullName: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    var imageUrl: String?
    
    var databaseService: DatabaseService?
    
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func getUserInfo(with completionHandler: @escaping (Bool) -> Void) {
        databaseService?.getMyProfileInfo(with: { (loaded) in
            if loaded {
                completionHandler(true)
            }
        })
    }
    
    func editCredentials(fullname: String, email: String, firstGenre: String, secondGenre: String, thirdGenre: String, imageUrl: String) {
        databaseService?.editCredentials(fullname: fullname, email: email, firstGenre: firstGenre, secondGenre: secondGenre, thirdGenre: thirdGenre, imageUrl: imageUrl)
    }
}
