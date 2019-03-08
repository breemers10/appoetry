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
    fileprivate var childFlow: PFlowController?
    private var presenterVC: UITabBarController
    private var navigationController: UINavigationController?

    init(with controller: UITabBarController) {
        presenterVC = controller
    }
    
    func start() {
        

//        guard let vc = mainViewController else { return }
//
//        let viewModel = MainViewModel()
//        viewModel.onCreatePostTap = { [weak self] in
//            self?.moveToCreatePost()
//        }
//        vc.viewModel = viewModel
//
//        navigationController = UINavigationController(rootViewController: vc)
//        guard let navController = navigationController else { return }
//        presenterVC.setViewControllers([navController], animated: true)
        setupTabBar()

      }
    
    func moveToCreatePost() {
        
        guard let createPostVC = createPostViewController else { return }
        navigationController?.pushViewController(createPostVC, animated: false)
    }
    
    private func setupTabBar() {
        guard let main = mainViewController else { return }
        let viewModel = MainViewModel()
        viewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePost()
        }
        main.viewModel = viewModel
        navigationController = UINavigationController(rootViewController: main)
        main.tabBarItem.image = UIImage(named: "for_you")
        main.tabBarItem.title = "Main Feed"
        
        guard let search = searchViewController else { return }
        let searchWrapper = UINavigationController(rootViewController: search)
        search.tabBarItem.image = UIImage(named: "search")
        search.tabBarItem.title = "Search"
        
        guard let favourites = favouritesViewController else { return }
        let favouritesWrapper = UINavigationController(rootViewController: favourites)
        favourites.tabBarItem.image = UIImage(named: "star")
        favourites.tabBarItem.title = "Favorites"
        
        guard let profile = profileViewController else { return }
        let profileWrapper = UINavigationController(rootViewController: profile)
        profile.tabBarItem.image = UIImage(named: "user_male")
        profile.tabBarItem.title = "My Profile"

        
        presenterVC.viewControllers = [navigationController!, searchWrapper, favouritesWrapper, profileWrapper]
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

