//
//  FollowingViewController.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 21.03.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class FollowingViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noUsersLabel: UILabel!
    
    var viewModel: FollowingViewModel?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filteredNames: [UserInfo]?
    
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
        retrieveUsers()
    }
    
    override func viewDidLayoutSubviews() {
        self.view.applyGradient()
    }
    
    private func retrieveUsers() {
        viewModel?.fetchFollowings(with: { [weak self] (fetched) in
            if fetched {
                self?.tableView.reloadData()
            }
        })
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        let names = viewModel?.databaseService?.userInfoArr
        filteredNames = names!.filter({( name : UserInfo ) -> Bool in
            return name.fullName!.lowercased().contains(searchText.lowercased()) || name.username!.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    private func setupNavigationBarItems() {
        
        let imageView = UIImageView(image: UIImage.logo)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        
        navigationItem.title = "Following"
    }
}

extension FollowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingUserCell", for: indexPath)
        
        if let myCell = cell as? FollowingTableViewCell {
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
            return filteredNames?.count ?? 0
        } else {
            noUsersLabel.isHidden = true
            return viewModel?.databaseService?.userInfoArr.count ?? 0
        }
    }
}

extension FollowingViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
