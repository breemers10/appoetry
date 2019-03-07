//
//  CreatePostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 07.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class CreatePostViewController: UIViewController {
         
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension CreatePostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
