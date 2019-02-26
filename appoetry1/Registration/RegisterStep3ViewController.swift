//
//  RegisterStep3ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class RegisterStep3ViewController: UIViewController {
    
    @IBOutlet weak var firstGenreTextField: UITextField!
    
    let viewModel = RegisterStep3ViewModel()
//    let genre = [
//        "Birthday",
//        "Christmas",
//        "Comedy",
//        "Erotic",
//        "Life",
//        "Love",
//        "Nature",
//        "Non-sense",
//        "Spring",
//        "Summer",
//        "Winter"
//    ]
//    var selectedGenre: String?
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGenrePicker()
        createToolbar()
    }
    
 
    func createGenrePicker() {
        let genrePicker = UIPickerView()
        genrePicker.delegate = self
        
        firstGenreTextField.inputView = genrePicker
        
        genrePicker.backgroundColor = .white
    }
    
    func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterStep3ViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstGenreTextField.inputAccessoryView = toolBar
        
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
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
        return viewModel.genre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.genre[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedGenre = viewModel.genre[row]
        firstGenreTextField.text = viewModel.selectedGenre
    }
}
