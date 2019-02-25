//
//  RegisterViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func nextFromFirstStep(_ sender: Any) {
         NotificationCenter.default.post(name: Notification.Name("goToRegStep2"), object: nil)
    }
    @IBAction func backToLogin(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToLogin"), object: nil)
    }
    
}
