//
//  SearchViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((Int) -> Void)?
    
    func createPost() {
        onCreatePostTap?()
    }
    
    func searchUser(fullName: String, username: String) {
        MySharedInstance.instance.userRegister.fullName = fullName
        MySharedInstance.instance.userRegister.username = username
    }
}
