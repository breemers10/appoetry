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
    
    var viewModel: RegisterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func nextFromFirstStep(_ sender: Any) {
        let providedEmailAddress = registerEmail.text
        let providedPassword = registerPassword.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        let isEmailAddressUsed = isEmailAlreadyTaken(emailAddressString: providedEmailAddress!)
        let isPasswordValid = isValidPassword(testStr: providedPassword)
        
        if isEmailAddressValid {
            
        } else {
            print("Email address is not valid")
            displayAlertMessage(messageToDisplay: "Email address is not valid")
        }
        
        if isEmailAddressUsed {
            self.displayAlertMessage(messageToDisplay: "User with this email already exists!")
            
        } else {    }
        
        if isPasswordValid {
            print("Password is valid")
            
        } else {
            print("Password is not valid")
            displayAlertMessage(messageToDisplay: "Password is not valid")
        }
        
        if self.confirmPassword.text == self.registerPassword.text {
            print("All good Senjor")
            guard
                let email = registerEmail.text,
                let password = registerPassword.text
                else { return }
            viewModel?.addCredentials(email: email, password: password)
            viewModel?.secondStep()
            
        } else {
            print("Passwords does not match!")
            displayAlertMessage(messageToDisplay: "Passwords does not match!")
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
    
    func isEmailAlreadyTaken(emailAddressString: String) -> Bool {
        var itIsUsed = true
        
        MySharedInstance.instance.ref.queryOrdered(byChild: "email").queryEqual(toValue: registerEmail.text!).observe(.value) { snapshot in
            if snapshot.exists() {
                itIsUsed = false
            } else {
                itIsUsed = true
            }
        }
        return itIsUsed
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
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

extension RegisterViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
