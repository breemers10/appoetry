//
//  RegisterStep2ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterStep2ViewController: UIViewController {
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    
    var viewModel: RegisterStep2ViewModel?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    
    func showDatePicker() {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateOfBirth?.inputAccessoryView = toolbar
        dateOfBirth?.inputView = datePicker
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    @IBAction func pressFromStepTwo(_ sender: Any) {
        guard
        let username = username.text,
        let fullName = fullName.text,
        let date = dateOfBirth.text
        else { return }
        
        let isUsernameValid = isValidUsername(testStr: username)
        
        if fullName.isEmpty == true {
            displayAlertMessage(messageToDisplay: "Full name field is empty!")
            return
        }

        if isUsernameValid {
            print("Username is valid")
            
        } else {
            print("Username is not valid")
            displayAlertMessage(messageToDisplay: "Username is not valid. Required at least 4 characters! ")
        }
        viewModel?.addSecondStepCredentials(username: username, fullName: fullName, dateOfBirth: date)
        viewModel?.toThirdStep()
        }
    
    func isValidUsername(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", "([A-Z0-9a-z._]).{4,}")
        return usernameTest.evaluate(with: testStr)
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

extension RegisterStep2ViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
