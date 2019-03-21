//
//  FollowersViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase


class FollowersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: FollowersViewModel?
    let createPostButton = UIButton(type: .system)
    
    var username: String?
    var fullName: String?
    var imageUrl: String?
    var userID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        MySharedInstance.instance.userInfo = []
        
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        retrieveUsers()
    }
    
    func retrieveUsers() {
        
        MySharedInstance.instance.userInfo = []
        var followers: String?
        
        MySharedInstance.instance.ref.child("users").child((viewModel?.idx)!).child("followers").observe(.childAdded, with: { (snapshot) in
            followers = snapshot.value as? String
            
            MySharedInstance.instance.ref.child("users").child(followers!).observeSingleEvent(of: .value, with: { (snap) in
                
                let usersObject = snap.value as? NSDictionary
                self.username = usersObject?["username"] as? String
                self.fullName = usersObject?["fullName"] as? String
                self.imageUrl = usersObject?["imageUrl"] as? String
                self.userID = snap.key
                
                var userInfo = UserInfo()
                userInfo.fullName = self.fullName
                userInfo.username = self.username
                userInfo.imageUrl = self.imageUrl
                userInfo.userID = self.userID
                
                MySharedInstance.instance.userInfo.append(userInfo)
                
                self.tableView.reloadData()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followersUserCell", for: indexPath) as! FollowersTableViewCell
        DispatchQueue.main.async {
            
            cell.usernameLabel.text = MySharedInstance.instance.userInfo[indexPath.row].username
            cell.fullNameLabel.text = MySharedInstance.instance.userInfo[indexPath.row].fullName
            cell.userImage.downloadImage(from: MySharedInstance.instance.userInfo[indexPath.row].imageUrl)
            
            cell.userImage.layer.cornerRadius = cell.userImage.frame.size.width / 2
            cell.userImage.clipsToBounds = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.onCellTap?(indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MySharedInstance.instance.userInfo.count
    }
    
    @objc func createPostButtonPressed(sender: UIButton) {
        viewModel?.onCreatePostTap?()
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

extension FollowersViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}

