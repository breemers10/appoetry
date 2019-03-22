//
//  EditProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstGenreField: UITextField!
    @IBOutlet weak var secondGenreField: UITextField!
    @IBOutlet weak var thirdGenreField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
        self.doneButton.applyButtonDesign()
    }
}
extension EditProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
