//
//  RegisterStep3ViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class RegisterStep3ViewController: UIViewController {
    
    @IBOutlet weak var firstGenreTextField: UITextField!
    @IBOutlet weak var secondGenreTextField: UITextField!
    @IBOutlet weak var thirdGenreTextField: UITextField!
    
    var viewModel: RegisterStep3ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGenrePicker()
        createToolbar()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    fileprivate let genrePicker1 = UIPickerView()
    fileprivate let genrePicker2 = UIPickerView()
    fileprivate let genrePicker3 = UIPickerView()
    
    func createGenrePicker() {
        genrePicker1.delegate = self
        firstGenreTextField.inputView = genrePicker1
        firstGenreTextField.text = Genres.none.selectedGenre
        genrePicker1.backgroundColor = .white
        
        genrePicker2.delegate = self
        secondGenreTextField.inputView = genrePicker2
        secondGenreTextField.text = Genres.none.selectedGenre
        genrePicker2.backgroundColor = .white
        
        genrePicker3.delegate = self
        thirdGenreTextField.inputView = genrePicker3
        thirdGenreTextField.text = Genres.none.selectedGenre
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
        return Genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genres(rawValue: row)?.selectedGenre
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePicker1 {
            viewModel?.realGenre = Genres(rawValue: row)
            firstGenreTextField.text = viewModel?.realGenre?.selectedGenre
            
        } else if pickerView == genrePicker2 {
            viewModel!.realGenre = Genres(rawValue: row)
            secondGenreTextField.text = viewModel?.realGenre?.selectedGenre
        } else if pickerView == genrePicker3 {
            viewModel?.realGenre = Genres(rawValue: row)
            thirdGenreTextField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}
