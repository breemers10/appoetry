//
//  SearchViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class SearchViewModel: NSObject {
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?
    
    var username: String?
    var fullName: String?
    var imageUrl: String?
    var userID: String?
    
    func createPost() {
        onCreatePostTap?()
    }
    
    func fetchUsers() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        MySharedInstance.instance.ref.child("users").observe(.childAdded, with: { (snapshot) in
            guard snapshot.key != id else { return }
            let usersObject = snapshot.value as? NSDictionary
            
            var userInfo = UserInfo()
            userInfo.fullName = usersObject?["username"] as? String
            userInfo.username = usersObject?["fullName"] as? String
            userInfo.imageUrl = usersObject?["imageUrl"] as? String
            userInfo.userID = snapshot.key
            
            MySharedInstance.instance.userInfo.append(userInfo)
        })
    }
}
