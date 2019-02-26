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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pressLogin(_ sender: Any) {
        
        let providedEmailAddress = emailLogin.text
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: providedEmailAddress!)
        
        if isEmailAddressValid {
            
            print("Email address is valid")
        } else {
            print("Email address is not valid")
            displayAlertMessage(messageToDisplay: "Email address is not valid")
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
        return  returnValue
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
        NotificationCenter.default.post(name: Notification.Name("goToReg"), object: nil)
    }
}
