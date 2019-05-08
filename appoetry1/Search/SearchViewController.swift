//
//  SearchViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 06.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noUsersLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredNames: [UserInfo]?
    
    var viewModel: SearchViewModel?
    let createPostButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        setupNavigationBarItems()
        addingTargetToCreatePostVC()
        retrieveUsers()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func retrieveUsers() {
        viewModel?.fetchUsers(with: { (fetched) in
            if fetched {
                self.tableView.reloadData()
            }
        })
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func filterContentForSearchText(_ searchText: String) {
        let names = viewModel?.databaseService?.userInfoArr
        filteredNames = names!.filter({( name : UserInfo ) -> Bool in
            return name.fullName!.lowercased().contains(searchText.lowercased()) || name.username!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath)
        
        if let myCell = cell as? SearchUserCell {
            if filteredNames?.isEmpty ?? false {
                if let userInfo = viewModel?.databaseService?.userInfoArr[indexPath.row] {
                    myCell.configure(userInfo: userInfo)
                }
            } else if filteredNames != nil{
                if let userInfo = filteredNames?[indexPath.row] {
                    myCell.configure(userInfo: userInfo)
                }
            } else {
                if let userInfo = viewModel?.databaseService?.userInfoArr[indexPath.row] {
                    myCell.configure(userInfo: userInfo)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.onCellTap?((viewModel?.databaseService?.userInfoArr[indexPath.row].userID)!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() && filteredNames?.isEmpty ?? false {
            noUsersLabel.isHidden = false
            return 0
        } else if filteredNames?.isEmpty ?? false {
            noUsersLabel.isHidden = true
            return viewModel?.databaseService?.userInfoArr.count ?? 0
        } else if filteredNames != nil {
            noUsersLabel.isHidden = true
            return (filteredNames?.count)!
        } else {
            noUsersLabel.isHidden = true
            return viewModel?.databaseService?.userInfoArr.count ?? 0
        }
    }
    
    @objc private func createPostButtonPressed(sender: UIButton) {
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
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension SearchViewController: ClassName {
    static var className: String {
        return String(describing: self)
    }
}
