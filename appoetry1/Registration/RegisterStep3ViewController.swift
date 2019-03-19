//
//  RegisterStep3ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterStep3ViewController: UIViewController {
    
    @IBOutlet weak var firstGenreTextField: UITextField!
    @IBOutlet weak var secondGenreTextField: UITextField!
    @IBOutlet weak var thirdGenreTextField: UITextField!
    
    var viewModel: RegisterStep3ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGenrePicker()
        createToolbar()
    }
    
    fileprivate let genrePicker1 = UIPickerView()
    fileprivate let genrePicker2 = UIPickerView()
    fileprivate let genrePicker3 = UIPickerView()
    
    func createGenrePicker() {
        genrePicker1.delegate = self
        firstGenreTextField.inputView = genrePicker1
        genrePicker1.backgroundColor = .white
        
        genrePicker2.delegate = self
        secondGenreTextField.inputView = genrePicker2
        genrePicker2.backgroundColor = .white
        
        genrePicker3.delegate = self
        thirdGenreTextField.inputView = genrePicker3
        genrePicker3.backgroundColor = .white
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterStep3ViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstGenreTextField.inputAccessoryView = toolBar
        secondGenreTextField.inputAccessoryView = toolBar
        thirdGenreTextField.inputAccessoryView = toolBar
        
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
    }
    
    @IBAction func completeRegistration(_ sender: Any) {
        guard
            let firstGenre = firstGenreTextField.text,
            let secondGenre = secondGenreTextField.text,
            let thirdGenre = thirdGenreTextField.text
            else { return }
        viewModel?.addThirdStepCredentials(firstGenre: firstGenre, secondGenre: secondGenre, thirdGenre: thirdGenre)
      
        viewModel?.toMainScreen()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RegisterStep3ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Genre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genre(rawValue: row)?.selectedGenre
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePicker1 {
            viewModel?.realGenre = Genre(rawValue: row)
            firstGenreTextField.text = viewModel?.realGenre?.selectedGenre
            
        } else if pickerView == genrePicker2 {
            viewModel!.realGenre = Genre(rawValue: row)
            secondGenreTextField.text = viewModel?.realGenre?.selectedGenre
        } else if pickerView == genrePicker3 {
            viewModel?.realGenre = Genre(rawValue: row)
            thirdGenreTextField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}

extension RegisterStep3ViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
