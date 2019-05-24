//
//  RegisterViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    var viewModel: RegisterViewModel?
    private var picker = UIImagePickerController()
    private var user: [UserInfo] = []
    private var isEmailUsed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    @objc func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func nextFromFirstStep(_ sender: Any) {
        let providedEmailAddress = registerEmail.text
        let providedPassword = registerPassword.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        let isPasswordValid = isValidPassword(password: providedPassword)
        
        if !isEmailAddressValid {
            displayAlertMessage(messageToDisplay: "Email address is not valid")
            return
        }
        
        viewModel?.checkIfEmailIsTaken(emailAddressString: providedEmailAddress!) { [weak self] (isTaken) in
            if isTaken {
                self?.isEmailUsed = true
                self?.displayAlertMessage(messageToDisplay: "User with this email already exists!")
            } else {
                self?.isEmailUsed = false
                
                if !isPasswordValid {
                    self?.displayAlertMessage(messageToDisplay: "Password is not valid")
                    return
                }
                
                if self?.confirmPassword.text == self?.registerPassword.text {
                    guard
                        let email = self?.registerEmail.text,
                        let password = self?.registerPassword.text
                        else { return }
                    
                    self?.viewModel?.addCredentials(email: email, password: password)
                    if !(self?.isEmailUsed)! {
                        self?.viewModel?.secondStep()
                    }
                } else {
                    self?.displayAlertMessage(messageToDisplay: "Passwords does not match!")
                }
            }
        }
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    func isValidPassword(password: String?) -> Bool {
        guard password != nil else { return false }
        let passwordRegEx = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordRegEx.evaluate(with: password)
    }
    
    func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
}
