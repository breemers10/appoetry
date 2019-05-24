//
//  LoginViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var emailLogin: UITextField!
    @IBOutlet private weak var passwordLogin: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var forgetPasswordButton: UIButton!
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLogin.text = "sss@sss.lv"
        passwordLogin.text = "Aa1234567"
        
        self.view.applyGradient()
    }
    
    @IBAction private func pressLogin(_ sender: Any) {
        
        viewModel?.wrongCredentials = { [weak self] in
            self?.displayAlertMessage(messageToDisplay: "E-mail or password are incorrect!")
        }
        viewModel?.signIn(email: emailLogin.text, password: passwordLogin.text)
    }
    
    private func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction private func pressRegister(_ sender: Any) {
        viewModel?.signUp()
    }
}
