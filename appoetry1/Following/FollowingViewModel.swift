//
//  FollowingViewModel.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class FollowingViewModel {
    
    var onCreatePostTap: (() -> Void)?
    var onCellTap: ((String) -> Void)?
    
    var followingArray: [String] = []
    var idx: String
    
    init(idx: String) {
        self.idx = idx        
    }
}
