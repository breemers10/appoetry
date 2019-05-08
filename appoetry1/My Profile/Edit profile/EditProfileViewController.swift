//
//  EditProfileViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 22.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var fullnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var firstGenreField: UITextField!
    @IBOutlet weak var secondGenreField: UITextField!
    @IBOutlet weak var thirdGenreField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var changePhotoButton: UIButton!
    
    var viewModel: EditProfileViewModel?
    var hasNewImage = false
    var url: URL?
    
    let picker = UIImagePickerController()
    
    fileprivate let genrePicker1 = UIPickerView()
    fileprivate let genrePicker2 = UIPickerView()
    fileprivate let genrePicker3 = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
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
            guard let self = self else { return }
            if fetched {
                guard let userInfo = self.viewModel?.databaseService?.userInfo else { return }
                let url = URL(string: userInfo.imageUrl!)
                
                self.usernameField.text = userInfo.username
                self.fullnameField.text = userInfo.fullName
                self.emailField.text = userInfo.email
                self.firstGenreField.text = userInfo.firstGenre
                self.secondGenreField.text = userInfo.secondGenre
                self.thirdGenreField.text = userInfo.thirdGenre
                
                self.imageView.kf.setImage(with: url)
            }
        })
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser!.uid
        
        let key = DatabaseService.instance.ref.child("posts").childByAutoId().key
        let storage = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
        
        let imageRef = storage.child("users").child(uid).child("\(key!).jpg")
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
    
    @objc func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
            hasNewImage = true
            changePhotoButton.isHidden = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func createGenrePicker() {
        genrePicker1.delegate = self
        firstGenreField.inputView = genrePicker1
        genrePicker1.backgroundColor = .white
        
        genrePicker2.delegate = self
        secondGenreField.inputView = genrePicker2
        genrePicker2.backgroundColor = .white
        
        genrePicker3.delegate = self
        thirdGenreField.inputView = genrePicker3
        genrePicker3.backgroundColor = .white
    }
    
    func addChangedCredentials() {
        guard
            let username = usernameField.text,
            let fullName = fullnameField.text,
            let email = emailField.text,
            let firstGenre = firstGenreField.text,
            let secondGenre = secondGenreField.text,
            let thirdGenre = thirdGenreField.text
            else { return }
        
        viewModel?.addChangedCredentials(imageUrl: url?.absoluteString, username: username, fullName: fullName, email: email, firstGenre: firstGenre, secondGenre: secondGenre, thirdGenre: thirdGenre, dateOfBirth: (self.viewModel?.databaseService?.userInfo.dateOfBirth)!)
        self.viewModel?.editCredentials()
        self.viewModel?.onEditProfileCompletion?()
    }
    
    func createToolbar() {
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        viewModel?.onDeleteButtonPressed?()
    }
    
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
            firstGenreField.text = viewModel?.realGenre?.selectedGenre
            
        } else if pickerView == genrePicker2 {
            viewModel!.realGenre = Genre(rawValue: row)
            secondGenreField.text = viewModel?.realGenre?.selectedGenre
        } else if pickerView == genrePicker3 {
            viewModel?.realGenre = Genre(rawValue: row)
            thirdGenreField.text = viewModel?.realGenre?.selectedGenre
        }
    }
}
extension EditProfileViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
