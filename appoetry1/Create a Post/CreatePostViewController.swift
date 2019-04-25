//
//  CreatePostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 07.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var genreField: UITextField!
    
    var viewModel: CreatePostViewModel?
    var registerStep3VM: RegisterStep3ViewModel?
    var picker = UIImagePickerController()
    var post = Post()
    var username: String?
    
    fileprivate let genrePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        createToolbar()
        createGenrePicker()
        
        previewImage.image = UIImage(named: "default_beach")
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func createGenrePicker() {
        
        genrePicker.delegate = self
        genreField.inputView = genrePicker
        genrePicker.backgroundColor = .white
    }
    
    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(RegisterStep3ViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        genreField.inputAccessoryView = toolBar
        
        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.previewImage.image = image
            selectPhotoButton.isHidden = true
            postButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func selectPhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func postButtonPressed(_ sender: Any) {
        let data = previewImage.image!.jpegData(compressionQuality: 0.6)
        
        
        viewModel?.get(author: self.username, poem: self.textView.text, genre: self.genreField.text, data: data)
        
        self.viewModel?.onMainScreen?()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreatePostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        if pickerView == genrePicker {
            viewModel?.realGenre = Genre(rawValue: row)
            genreField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}

extension CreatePostViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
