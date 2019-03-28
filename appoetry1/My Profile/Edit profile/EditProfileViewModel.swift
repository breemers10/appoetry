//
//  EditProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class EditProfileViewModel: NSObject {
    
    var onEditProfileCompletion: (() -> Void)?
    var realGenre: Genre?
    
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
    
    func addChangedCredentials(imageUrl: String, username: String, fullName: String, email: String, firstGenre: String, secondGenre: String, thirdGenre: String) {
        MySharedInstance.instance.userRegister.imageUrl = imageUrl
        MySharedInstance.instance.userRegister.username = username
        MySharedInstance.instance.userRegister.fullName = fullName
        MySharedInstance.instance.userRegister.email = email
        MySharedInstance.instance.userRegister.firstGenre = firstGenre
        MySharedInstance.instance.userRegister.secondGenre = secondGenre
        MySharedInstance.instance.userRegister.thirdGenre = thirdGenre
    }
    
    func getUserInfo() {
        databaseService?.getMyProfileInfo()
    }
}
