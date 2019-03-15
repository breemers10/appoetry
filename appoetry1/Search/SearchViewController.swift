//
//  SearchViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SearchViewModel?
    let createPostButton = UIButton(type: .system)
    
    var user: [UserInfo] = []
    var username: String?
    var fullName: String?
    var imageUrl: String?
    var userID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        retrieveUsers()
        
        
    }
    
    func retrieveUsers() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        MySharedInstance.instance.ref.child("users").observe(.childAdded, with: { (snapshot) in
            guard snapshot.key != id else { return }
            let usersObject = snapshot.value as? NSDictionary
            self.username = usersObject?["username"] as? String
            self.fullName = usersObject?["fullName"] as? String
            self.imageUrl = usersObject?["imageUrl"] as? String
            self.userID = snapshot.key
            self.user.append(UserInfo(fullName: self.fullName, username: self.username, userID: self.userID, imageUrl: self.imageUrl))
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath) as! SearchUserCell
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            cell.usernameLabel.text = self.user[indexPath.row].username
            cell.fullNameLabel.text = self.user[indexPath.row].fullName
            cell.userImage.downloadImage(from: self.user[indexPath.row].imageUrl)
            
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
            cell.userImage.clipsToBounds = true
            
            self.checkFollowing(indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        let key = MySharedInstance.instance.ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        MySharedInstance.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (ke, value) in following {
                    if value as? String == self.user[indexPath.row].userID {
                        isFollower = true
                        
                        MySharedInstance.instance.ref.child("users").child(uid).child("following/\(ke)").removeValue()
                        MySharedInstance.instance.ref.child("users").child(self.user[indexPath.row].userID!).child("followers/\(ke)").removeValue()
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            if !isFollower {
                let following = ["following/\(String(describing: key))" : self.user[indexPath.row].userID]
                let followers = ["followers/\(String(describing: key))" : uid]
                
                MySharedInstance.instance.ref.child("users").child(uid).updateChildValues(following)
                MySharedInstance.instance.ref.child("users").child(self.user[indexPath.row].userID!).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func checkFollowing(indexPath: IndexPath) {
        let uid = Auth.auth().currentUser!.uid
        MySharedInstance.instance.ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            if let following = snapshot.value as? [String : AnyObject] {
                for (_, value) in following {
                    if value as? String == self.user[indexPath.row].userID {
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        MySharedInstance.instance.ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    @objc func createPostButtonPressed(sender: UIButton) {
        viewModel?.createPost()
    }
    
    private func addingTargetToCreatePostVC() {
        createPostButton.addTarget(self, action: #selector(self.createPostButtonPressed(sender:)), for: .touchUpInside)
    }
    
    private func setupNavigationBarItems() {
        
        createPostButton.setImage(UIImage(named: "create_new")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createPostButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createPostButton)
        
        let titleTextAttributed: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(displayP3Red: 110/255, green: 37/255, blue: 37/255, alpha: 0.85), .font: UIFont(name: "SnellRoundhand-Bold", size: 30) as Any]
        
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributed
        navigationItem.title = "Appoetry"
    }
}

extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

extension SearchViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
