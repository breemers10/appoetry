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
 
    init(with controller: UITabBarController) {
        presenterVC = controller
    }
    
    func start() {
        setupTabBar()
    }
    
    private func setupTabBar() {
        guard let main = mainViewController else { return }
        let mainWrapper = UINavigationController(rootViewController: main)
        main.tabBarItem.image = UIImage(named: "for_you")
    
        guard let search = searchViewController else { return }
        let searchWrapper = UINavigationController(rootViewController: search)
        search.tabBarItem.image = UIImage(named: "search")
    
        guard let favourites = favouritesViewController else { return }
        let favouritesWrapper = UINavigationController(rootViewController: favourites)
        favourites.tabBarItem.image = UIImage(named: "star")
    
        guard let profile = profileViewController else { return }
        let profileWrapper = UINavigationController(rootViewController: profile)
        profile.tabBarItem.image = UIImage(named: "user_male")
        
        presenterVC.viewControllers = [mainWrapper, searchWrapper, favouritesWrapper, profileWrapper]
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

