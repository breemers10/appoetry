//
//  ProfileViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 08.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
    var onCreatePostTap: (() -> Void)?
    
    func createPost() {
        onCreatePostTap?()
    }
}
