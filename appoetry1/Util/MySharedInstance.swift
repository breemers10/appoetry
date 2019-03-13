//
//  MySharedInstance.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MySharedInstance {
    static let instance = MySharedInstance()
    var ref = Database.database().reference()
    var userRegister = UserRegister()
    let storageRef = Storage.storage().reference()
}
