//
//  CreatePostViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 07.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class CreatePostViewController: UIViewController {
    @IBOutlet private weak var postButton: UIButton!
    @IBOutlet private weak var selectPhotoButton: UIButton!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var previewImage: UIImageView!
    @IBOutlet private weak var genreField: UITextField!
    
    var viewModel: CreatePostViewModel?
    private var picker = UIImagePickerController()
    private var post = Post()
    private var username: String?
    
    fileprivate let genrePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        createToolbar()
        createGenrePicker()
        
        previewImage.image = UIImage.post_default
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func createGenrePicker() {
        
        genrePicker.delegate = self
        genreField.inputView = genrePicker
        genreField.text = Genres.none.selectedGenre
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
    

    @IBAction private func selectPhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func postButtonPressed(_ sender: Any) {
        let data = previewImage.image!.jpegData(compressionQuality: 0.6)
        
        viewModel?.storePost(author: self.username, poem: self.textView.text, genre: self.genreField.text, data: data)
        
        viewModel?.onMainScreen?()
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
        return Genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Genres(rawValue: row)?.selectedGenre
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePicker {
            viewModel?.realGenre = Genres(rawValue: row)
            genreField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            previewImage.image = image
            selectPhotoButton.isHidden = true
            postButton.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
}
