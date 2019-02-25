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
    
    let genre = [
        "Birthday",
        "Christmas",
        "Comedy",
        "Erotic",
        "Life",
        "Love",
        "Nature",
        "Non-sense",
        "Spring",
        "Summer",
        "Winter"
    ]
    var selectedGenre: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGenrePicker()
        
    }
    
 
    func createGenrePicker() {
        let genrePicker = UIPickerView()
        genrePicker.delegate = self
        
        firstGenreTextField.inputView = genrePicker
    }
    
}
extension RegisterStep3ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genre.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genre[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedGenre = genre[row]
        firstGenreTextField.text = selectedGenre
    }
}
