//
//  LoginViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLogin.text = "fff@fff.lv"
        passwordLogin.text = "Aa1234567"
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        
        viewModel?.signIn(email: emailLogin.text, password: passwordLogin.text)
        viewModel?.wrongCredentials = { [weak self] in
            self?.displayAlertMessage(messageToDisplay: "E-mail or password are incorrect!")
        }
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func pressRegister(_ sender: Any) {
        viewModel?.signUp()
    }
}

extension LoginViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
