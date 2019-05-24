//
//  RegisterStep2ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterStep2ViewController: UIViewController {
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    
    var viewModel: RegisterStep2ViewModel?
    private let datePicker = UIDatePicker()
    private var isUsernameUsed = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
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
        
        let isFullNameValid = isValidFullName(fullName: fullName)
        let isUsernameValid = isValidUsername(username: username)
        
        if !isFullNameValid {
            displayAlertMessage(messageToDisplay: "Fullname is not valid!")
        }
        
        if !isUsernameValid {
            displayAlertMessage(messageToDisplay: "Username is not valid!")
        } else {
            
            viewModel?.checkIfUsernameIsUsed(username: username) { [weak self] isTaken in
                if isTaken {
                    self?.isUsernameUsed = true
                    self?.displayAlertMessage(messageToDisplay: "User with this username already exists!")
                    
                } else {
                    self?.isUsernameUsed = false
                    self?.viewModel?.addSecondStepCredentials(username: username, fullName: fullName, dateOfBirth: date)
                    self?.viewModel?.toThirdStep()
                }
            }
        }
    }
    
    func isValidFullName(fullName: String?) -> Bool {
        guard fullName != nil else { return false }
        
        let fullNameRegEx = NSPredicate(format: "SELF MATCHES %@", "([A-Z0-9a-z._]).{1,20}")
        return fullNameRegEx.evaluate(with: fullName)
    }
    
    func isValidUsername(username: String?) -> Bool {
        guard username != nil else { return false }
        
        let usernameRegEx = NSPredicate(format: "SELF MATCHES %@", "([A-Z0-9a-z._]).{4,12}")
        return usernameRegEx.evaluate(with: username)
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
