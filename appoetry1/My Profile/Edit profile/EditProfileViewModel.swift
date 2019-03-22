//
//  EditProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewModel: NSObject {
    
    var onEditProfileCompletion: (() -> Void)?
    
    var username: String?
    var email: String?
    var fullName: String?
    var firstGenre: String?
    var secondGenre: String?
    var thirdGenre: String?
    var imageUrl: String?
    
    override init() {
        super.init()
        getUserInfo()
    }
    
    func getUserInfo() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        MySharedInstance.instance.ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
            let usersObject = snapshot.value as? NSDictionary
            
            self.username = usersObject?["username"] as? String
            self.email = usersObject?["email"] as? String
            self.fullName = usersObject?["fullName"] as? String
            self.firstGenre = usersObject?["firstGenre"] as? String
            self.secondGenre = usersObject?["secondGenre"] as? String
            self.thirdGenre = usersObject?["thirdGenre"] as? String
            self.imageUrl = usersObject?["imageUrl"] as? String
            
            MySharedInstance.instance.ref.child("users").child(id).updateChildValues(usersObject as! [AnyHashable : Any])
        })
    }

}
