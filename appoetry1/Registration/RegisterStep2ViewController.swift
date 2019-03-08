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
        viewModel?.addSecondStepCredentials(username: username, fullName: fullName, dateOfBirth: date)
        viewModel?.toThirdStep()
    }
}

extension RegisterStep2ViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
