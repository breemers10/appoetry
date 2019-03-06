//
//  UserServices.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

struct User {
    let email: String?
}

protocol PUserService {
    var user: User? { get }
    
    func loginWithEmailAndPassword(with email: String, with password: String, with completionHandler: @escaping ((User?, String?) -> Void))
}

class UserService: PUserService {
    
    var user: User?
    
    func loginWithEmailAndPassword(with email: String, with password: String, with completionHandler: @escaping ((User?, String?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                completionHandler(nil, "Wrong credentials")
                return
            }
            self.user = User.init(email: Auth.auth().currentUser?.email)
            completionHandler(self.user, nil)
        }
    }
    
    public func weirdFunction() {
        
    }
}
