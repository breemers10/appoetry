//
//  MainFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

class MainFlow: PFlowController {
    
    var onCompletion: (() -> Void)?
    var onSignOutCompletion: (() -> Void)?
    var onMainStart: ((UITabBarController) -> Void)?
    var onSuccessfullPost: (() -> ())?
    var userService: PUserService
    fileprivate var childFlow: PFlowController?
    private var presenterVC: UITabBarController?
    private var mainWrapper: UINavigationController?
    private var searchWrapper: UINavigationController?
    private var favouritesWrapper: UINavigationController?
    private var profileWrapper: UINavigationController?

    init(userService: PUserService) {
        self.userService = userService
    }
    
    func start() {
        
        setupTabBar()
        guard let mainRootVC = presenterVC else { return }
        onMainStart?(mainRootVC)
      }
    
    func moveToCreatePostFromMain() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.onMainScreen = { [weak self] in
            self?.mainWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel
        mainWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToCreatePostFromSearch() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.onMainScreen = { [weak self] in
            self?.searchWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel

        searchWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToCreatePostFromFavourites() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.onMainScreen = { [weak self] in
            self?.favouritesWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel

        favouritesWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToCreatePostFromProfile() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.onMainScreen = { [weak self] in
            self?.profileWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel

        profileWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToMainScreen() {
        
    }
    
    func moveToLogin() {
        
    }
    
    private func setupTabBar() {
        presenterVC = UITabBarController()
        guard let main = mainViewController else { return }
        let viewModel = MainViewModel()
        viewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromMain()
        }
        main.viewModel = viewModel
        mainWrapper = UINavigationController(rootViewController: main)
        guard let mw = mainWrapper else { return }
        main.tabBarItem.image = UIImage(named: "for_you")
        main.tabBarItem.title = "Main Feed"
        
        guard let search = searchViewController else { return }
        let searchViewModel = SearchViewModel()
        searchViewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromSearch()
        }
        search.viewModel = searchViewModel
        searchWrapper = UINavigationController(rootViewController: search)
        guard let sw = searchWrapper else { return }
        search.tabBarItem.image = UIImage(named: "search")
        search.tabBarItem.title = "Search"
        
        guard let favourites = favouritesViewController else { return }
        let favouritesViewModel = FavouritesViewModel()
        favouritesViewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromFavourites()
        }
        favourites.viewModel = favouritesViewModel
        favouritesWrapper = UINavigationController(rootViewController: favourites)
        guard let fw = favouritesWrapper else { return }
        favourites.tabBarItem.image = UIImage(named: "star")
        favourites.tabBarItem.title = "Favorites"
        
        guard let profile = profileViewController else { return }
        let profileViewModel = ProfileViewModel()
        profileViewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromProfile()
        }
        
        profile.viewModel = profileViewModel
        profileWrapper = UINavigationController(rootViewController: profile)
        guard let pw = profileWrapper else { return }
        profile.tabBarItem.image = UIImage(named: "user_male")
        profile.tabBarItem.title = "My Profile"

        presenterVC?.viewControllers = [mw, sw, fw, pw]
        }
    
   private func postCreated() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel()
        createPostViewModel.onMainScreen = { [weak self] in
            self?.moveToMainScreen()
        }
        createPostVC.viewModel = createPostViewModel
    }
    private func signOut() {
        
        guard let profileVC = profileViewController else { return }
        let profileViewModel = ProfileViewModel()
        profileViewModel.onSignOutTap = { [weak self] in
            self?.moveToLogin()
        }
        profileVC.viewModel = profileViewModel
    }
}
extension MainFlow {
    
    fileprivate var mainSB: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: Bundle.main)
    }
    fileprivate var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainViewController
    }
    fileprivate var searchViewController: SearchViewController? {
        return mainSB.instantiateViewController(withIdentifier: SearchViewController.className) as? SearchViewController
    }
    fileprivate var favouritesViewController: FavouritesViewController? {
        return mainSB.instantiateViewController(withIdentifier: FavouritesViewController.className) as? FavouritesViewController
    }
    fileprivate var profileViewController: ProfileViewController? {
        return mainSB.instantiateViewController(withIdentifier: ProfileViewController.className) as? ProfileViewController
    }
    fileprivate var createPostViewController: CreatePostViewController? {
        return mainSB.instantiateViewController(withIdentifier: CreatePostViewController.className) as? CreatePostViewController
    }
}

