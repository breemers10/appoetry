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
    
//    private var mainTab: MainTabBarController? {
//        return mainSB.instantiateViewController(withIdentifier: MainViewController.className) as? MainTabBarController
//    }
    
    init(with controller: UITabBarController) {
        presenterVC = controller
        
        guard let main = mainViewController else { return }
        let mainWrapper = UINavigationController(rootViewController: main)
        main.tabBarItem.image = UIImage(named: "for_you")
        presenterVC.viewControllers = [mainWrapper] as? [UIViewController]
    }
    
    func start() {
        setupMainTab()
        setupSearchTab()
        setupProfileTab()
        setupFavoritesTab()
        
        
    }
    
    private func setupMainTab() {
        let mainController = UINavigationController(rootViewController: mainViewController!)
        mainViewController?.tabBarItem.image = UIImage(named: "for_you")
//        mainController.tabBarItem.image = UIImage(named: "for_you")
    }
    private func setupSearchTab() {
        let searchController = UINavigationController(rootViewController: SearchViewController())
        searchController.tabBarItem.image = UIImage(named: "search")
    }
    
    private func setupProfileTab() {
        let profileController = UINavigationController(rootViewController: ProfileViewController())
        profileController.tabBarItem.image = UIImage(named: "user_male")
        profileController.tabBarItem.selectedImage = UIImage(named: "user_male")
        profileController.tabBarItem = UITabBarItem(title: "My Profile", image: UIImage(named: "user_male"), selectedImage: UIImage(named: "user_male"))
    }
    private func setupFavoritesTab() {
        let favoritesController = UINavigationController(rootViewController: FavouritesViewController())
        favoritesController.tabBarItem.image = UIImage(named: "star")
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
}
