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
        
        let url = URL(string: (self.viewModel?.imageUrl)!)
        
        self.usernameField.text = self.viewModel?.username
        self.fullnameField.text = self.viewModel?.fullName
        self.emailField.text = self.viewModel?.email
        self.firstGenreField.text = self.viewModel?.firstGenre
        self.secondGenreField.text = self.viewModel?.secondGenre
        self.thirdGenreField.text = self.viewModel?.thirdGenre
        
        self.imageView.kf.setImage(with: url)
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
        self.doneButton.applyButtonDesign()
    }
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        guard
            let username = usernameField.text,
            let fullName = fullnameField.text,
            let email = emailField.text,
            let firstGenre = firstGenreField.text,
            let secondGenre = secondGenreField.text,
            let thirdGenre = thirdGenreField.text
            else { return }
        
        let uid = Auth.auth().currentUser!.uid
        
        let key = MySharedInstance.instance.ref.child("posts").childByAutoId().key
        let storage = Storage.storage().reference(forURL : "gs://appoetry1.appspot.com")
        
        let imageRef = storage.child("users").child(uid).child("\(key!).jpg")
        
        let data = imageView.image!.jpegData(compressionQuality: 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                if let url = url {
                    
                    self.viewModel?.addChangedCredentials(imageUrl: url.absoluteString, username: username, fullName: fullName, email: email, firstGenre: firstGenre, secondGenre: secondGenre, thirdGenre: thirdGenre)
                }
            })
        }
        uploadTask.resume()
        
        viewModel?.onEditProfileCompletion?()
    }
    
    @objc func handleSelectProfileImageView() {
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imageView.image = image
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
