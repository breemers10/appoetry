//
//  EditProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

final class EditProfileViewController: UIViewController{
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var fullnameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var firstGenreField: UITextField!
    @IBOutlet private weak var secondGenreField: UITextField!
    @IBOutlet private weak var thirdGenreField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var changePhotoButton: UIButton!
    
    var viewModel: EditProfileViewModel?
    private var hasNewImage = false
    private var url: URL?
    
    private let picker = UIImagePickerController()
    
    fileprivate let genrePicker1 = UIPickerView()
    fileprivate let genrePicker2 = UIPickerView()
    fileprivate let genrePicker3 = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        fullnameField.delegate = self
        emailField.delegate = self
        createGenrePicker()
        createToolbar()
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        fetchUserInfo()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    func fetchUserInfo() {
        viewModel?.getUserInfo(with: { [weak self] (fetched) in
            if fetched {
                guard let userInfo = self?.viewModel?.databaseService?.userInfo else { return }

                
                self?.usernameField.text = userInfo.username
                self?.fullnameField.text = userInfo.fullName
                self?.emailField.text = userInfo.email
                self?.firstGenreField.text = userInfo.firstGenre
                self?.secondGenreField.text = userInfo.secondGenre
                self?.thirdGenreField.text = userInfo.thirdGenre
                
                guard let imageUrl = userInfo.imageUrl else { return }
                let url = URL(string: imageUrl)
                self?.imageView.kf.setImage(with: url)
            }
        })
    }
    
    @IBAction private func changePhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func doneButtonPressed(_ sender: Any) {
        guard let fullName = fullnameField.text else { return }
        let isFullNameValid = isValidFullName(fullName: fullName)
        
        if !isFullNameValid {
            displayAlertMessage(messageToDisplay: "Fullname is not valid!")
            return
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let key = DatabaseService.instance.ref.child("posts").childByAutoId().key else { return }
        let storage = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
        
        let imageRef = storage.child("users").child(uid).child("\(key).jpg")
        if hasNewImage == true {
            let data = imageView.image!.jpegData(compressionQuality: 0.6)
            
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                
                imageRef.downloadURL(completion: { [weak self] (url, err) in
                    guard let self = self else { return }
                    if err != nil {
                        print(err!.localizedDescription)
                    }
                    self.url = url
                    
                    self.addChangedCredentials()
                })
            }
            uploadTask.resume()
        } else {
            url = URL(string: (self.viewModel?.databaseService?.userInfo.imageUrl)!)
            addChangedCredentials()
        }
    }
    
    @objc private func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    private func createGenrePicker() {
        genrePicker1.delegate = self
        firstGenreField.inputView = genrePicker1
        firstGenreField.text = Genres.none.selectedGenre
        genrePicker1.backgroundColor = .white
        
        genrePicker2.delegate = self
        secondGenreField.inputView = genrePicker2
        secondGenreField.text = Genres.none.selectedGenre
        genrePicker2.backgroundColor = .white
        
        genrePicker3.delegate = self
        thirdGenreField.inputView = genrePicker3
        thirdGenreField.text = Genres.none.selectedGenre
        genrePicker3.backgroundColor = .white
    }
    
    func addChangedCredentials() {
        guard
            let fullName = fullnameField.text,
            let email = emailField.text,
            let firstGenre = firstGenreField.text,
            let secondGenre = secondGenreField.text,
            let thirdGenre = thirdGenreField.text,
            let imageUrl = url?.absoluteString
            else { return }
        
        self.viewModel?.editCredentials(fullname: fullName, email: email, firstGenre: firstGenre, secondGenre: secondGenre, thirdGenre: thirdGenre, imageUrl: imageUrl)
        self.viewModel?.onEditProfileCompletion?()
    }
    
    private func createToolbar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        firstGenreField.inputAccessoryView = toolBar
        secondGenreField.inputAccessoryView = toolBar
        thirdGenreField.inputAccessoryView = toolBar

        toolBar.barTintColor = .white
        toolBar.backgroundColor = .white
    }
    
    private func isValidFullName(fullName: String?) -> Bool {
        guard fullName != nil else { return false }
        
        let fullNameRegEx = NSPredicate(format: "SELF MATCHES %@", "([A-Z0-9a-z._]).{1,20}")
        return fullNameRegEx.evaluate(with: fullName)
    }
    
    private func displayAlertMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction private func deletePressed(_ sender: Any) {
        viewModel?.onDeleteButtonPressed?()
    }
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            firstGenreField.text = viewModel?.realGenre?.selectedGenre
            
        } else if pickerView == genrePicker2 {
            viewModel?.realGenre = Genres(rawValue: row)
            secondGenreField.text = viewModel?.realGenre?.selectedGenre
        } else if pickerView == genrePicker3 {
            viewModel?.realGenre = Genres(rawValue: row)
            thirdGenreField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}

extension EditProfileViewController
: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            hasNewImage = true
            changePhotoButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
