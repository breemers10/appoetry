//
//  LoginViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var validationMessage: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        validationMessage.isHidden = true
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        
        validationMessage.isHidden = true
        
        guard let email = emailLogin.text, emailLogin.text?.characters.count != 0 else {
            validationMessage.isHidden = false
            validationMessage.text = "Please enter your email!"
            return
        }
        
        if isValidEmail(emailID:email) == false {
            validationMessage.isHidden = false
            validationMessage.text = "Please enter valid email address!"
        }
        
        guard let password = passwordLogin.text, passwordLogin.text?.characters.count != 0 else {
            validationMessage.isHidden = false
            validationMessage.text = "Please enter your password"
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name("goToMain"), object: nil)
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    @IBAction func pressRegister(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("goToReg"), object: nil)
    }
}
