//
//  Dependencies.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 01.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

protocol PDependencies {
    var userService: UserService { get }
}

class Dependencies: PDependencies {
    static var instance = Dependencies()
    var userService = UserService()
}
