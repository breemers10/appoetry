//
//  MainFlow.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit

final class MainFlow: PFlowController {
    
    var onCompletion: (() -> Void)?
    var onSignOutCompletion: (() -> Void)?
    var onMainStart: ((UITabBarController) -> Void)?
    var onSuccessfullPost: (() -> ())?
    var onSuccessfullUnfavorite: (() -> ())?
    var onSuccessfulProfileEdit: (() -> ())?
    var onSuccessfulPostEdit: (() -> ())?
    var onSuccessfulDeletion: (() -> ())?
    var onSuccessfulPostDeletion: (() -> ())?
    var databaseService: PDatabaseService
    fileprivate var childFlow: PFlowController?
    private var presenterVC: UITabBarController?
    private var mainWrapper: UINavigationController?
    private var searchWrapper: UINavigationController?
    private var favoritesWrapper: UINavigationController?
    private var myProfileWrapper: UINavigationController?
    
    private var mainSB = UIStoryboard.getStoryboard(with: StoryboardNames.main)
    
    init(databaseService: PDatabaseService) {
        self.databaseService = databaseService
    }
    
    func start() {
        setupTabBar()
        guard let mainRootVC = presenterVC else { return }
        onMainStart?(mainRootVC)
    }
    
    func moveToCreatePostFromMain() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel(databaseService: databaseService as! DatabaseService)
        createPostViewModel.onMainScreen = { [weak self] in
            self?.mainWrapper?.popViewController(animated: true)
            self?.onSuccessfullPost?()
        }
        createPostVC.viewModel = createPostViewModel
        mainWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToCreatePostFromSearch() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel(databaseService: databaseService as! DatabaseService)
        createPostViewModel.onMainScreen = { [weak self] in
            self?.searchWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel
        
        searchWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToCreatePostFromFavorites() {
        
        guard let createPostVC = createPostViewController else { return }
        let createPostViewModel = CreatePostViewModel(databaseService: databaseService as! DatabaseService)
        createPostViewModel.onMainScreen = { [weak self] in
            self?.favoritesWrapper?.popViewController(animated: true)
        }
        createPostVC.viewModel = createPostViewModel
        
        favoritesWrapper?.pushViewController(createPostVC, animated: false)
    }
    
    func moveToEditProfile() {
        
        guard let editProfileVC = editProfileViewController else { return }
        let editProfileViewModel = EditProfileViewModel(databaseService: databaseService as! DatabaseService)
        editProfileViewModel.onEditProfileCompletion = { [weak self] in
            self?.onSuccessfulProfileEdit?()
            self?.myProfileWrapper?.popViewController(animated: true)
        }
        editProfileViewModel.onDeleteButtonPressed = { [weak self] in
            self?.moveToDelete()
        }
        editProfileVC.viewModel = editProfileViewModel
        
        myProfileWrapper?.pushViewController(editProfileVC, animated: false)
    }
    
    func moveToDelete() {
        
        guard let deleteAccVC = deleteAccViewController else { return }
        let deleteAccVM = DeleteAccViewModel(databaseService: databaseService as! DatabaseService)
        deleteAccVM.onSuccessfulDeletion = { [weak self] in
            self?.onSuccessfulDeletion?()
        }
        deleteAccVM.onCancelTap = { [weak self] in
            self?.myProfileWrapper?.popViewController(animated: true)
        }
        deleteAccVC.viewModel = deleteAccVM
        myProfileWrapper?.pushViewController(deleteAccVC, animated: true)
    }
    
    func moveToProfiles(idx: String) {
        
        guard let profilesVC = profilesViewController else { return }
        let profilesViewModel = ProfilesViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        profilesViewModel.onFollowingButtonTap = { [weak self] in
            self?.moveToFollowings(idx: idx)
        }
        profilesViewModel.onFollowersButtonTap = { [weak self] in
            self?.moveToFollowers(idx: idx)
        }
        profilesViewModel.onPostTap = { [weak self] idx in
            self?.moveToPost(idx: idx)
        }
        profilesVC.viewModel = profilesViewModel
        searchWrapper?.pushViewController(profilesVC, animated: false)
    }
    
    func moveToProfilesFromFollowings(idx: String) {
        
        guard let profilesVC = profilesViewController else { return }
        let profilesViewModel = ProfilesViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        profilesViewModel.onFollowingButtonTap = { [weak self] in
            self?.moveToFollowings(idx: idx)
        }
        profilesViewModel.onFollowersButtonTap = { [weak self] in
            self?.moveToFollowers(idx: idx)
        }
        profilesVC.viewModel = profilesViewModel
        myProfileWrapper?.pushViewController(profilesVC, animated: false)
    }
    
    func moveToProfilesFromFollowers(idx: String) {
        
        guard let profilesVC = profilesViewController else { return }
        let profilesViewModel = ProfilesViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        profilesViewModel.onFollowingButtonTap = { [weak self] in
            self?.moveToFollowings(idx: idx)
        }
        profilesViewModel.onFollowersButtonTap = { [weak self] in
            self?.moveToFollowers(idx: idx)
        }
        profilesVC.viewModel = profilesViewModel
        myProfileWrapper?.pushViewController(profilesVC, animated: false)
    }
    
    func moveToPost(idx: String) {
        guard let postVC = postViewController else { return }
        let postVM = PostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        postVM.onAuthorTap = { [weak self] idx in
            self?.moveToProfiles(idx: idx)
        }
        postVC.viewModel = postVM
        searchWrapper?.pushViewController(postVC, animated: true)
    }
    
    func moveToPostFromMain(idx: String) {
        guard let postVC = postViewController else { return }
        let postVM = PostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        postVM.onAuthorTap = { [weak self] idx in
            self?.moveToProfilesFromMain(idx: idx)
        }
        postVC.viewModel = postVM
        mainWrapper?.pushViewController(postVC, animated: true)
    }
    
    func moveToPostFromFavorites(idx: String) {
        guard let postVC = postViewController else { return }
        let postVM = PostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        postVM.onAuthorTap = { [weak self] idx in
            self?.moveToProfilesFromMain(idx: idx)
        }
        postVC.viewModel = postVM
        favoritesWrapper?.pushViewController(postVC, animated: true)
    }
    
    func moveToPostFromMyProfile(idx: String) {
        guard let postVC = postViewController else { return }
        let postVM = PostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        postVM.onAuthorTap = { [weak self] idx in
            self?.moveToProfilesFromMain(idx: idx)
        }
        postVC.viewModel = postVM
        myProfileWrapper?.pushViewController(postVC, animated: true)
    }
    
    func moveToEditPostFromMain(idx: String) {
        guard let editPostVC = editPostViewController else { return }
        let editPostVM = EditPostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        editPostVM.onSuccessfulDeletion = { [weak self] in
            self?.onSuccessfulPostDeletion?()
            self?.mainWrapper?.popViewController(animated: true)
        }
        editPostVM.onSuccessfulEdit = { [weak self] in
            self?.onSuccessfulPostEdit?()
            self?.mainWrapper?.popViewController(animated: true)
        }
        editPostVC.viewModel = editPostVM
        mainWrapper?.pushViewController(editPostVC, animated: true)
    }
    
    func moveToEditPostFromMyProfile(idx: String) {
        guard let editPostVC = editPostViewController else { return }
        let editPostVM = EditPostViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        editPostVM.onSuccessfulDeletion = { [weak self] in
            self?.onSuccessfulPostDeletion?()
            self?.myProfileWrapper?.popViewController(animated: true)
        }
        editPostVM.onSuccessfulEdit = { [weak self] in
            self?.onSuccessfulPostEdit?()
            self?.myProfileWrapper?.popViewController(animated: true)
        }
        editPostVC.viewModel = editPostVM
        myProfileWrapper?.pushViewController(editPostVC, animated: true)
    }
    
    func moveToProfilesFromMain(idx: String) {
        
        guard let profilesVC = profilesViewController,
            let myProfilesVC = myProfileViewController
            else { return }
        
        onSuccessfulProfileEdit = {
            myProfilesVC.fetchUserInfo()
        }
        
        let profilesViewModel = ProfilesViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        profilesViewModel.onFollowingButtonTap = { [weak self] in
            self?.moveToFollowings(idx: idx)
        }
        profilesViewModel.onFollowersButtonTap = { [weak self] in
            self?.moveToFollowers(idx: idx)
        }
        
        let myProfileVM = MyProfileViewModel(databaseService: databaseService as! DatabaseService)
        myProfileVM.onFollowingButtonTap = { [weak self] idx in
            self?.moveToFollowings(idx: idx)
        }
        myProfileVM.onFollowersButtonTap = { [weak self] idx in
            self?.moveToFollowers(idx: idx)
        }
        
        profilesVC.viewModel = profilesViewModel
        myProfilesVC.viewModel = myProfileVM
        
        if idx == DatabaseService.instance.currentUserID {
            mainWrapper?.pushViewController(myProfilesVC, animated: true)
        } else {
            mainWrapper?.pushViewController(profilesVC, animated: true)
        }
    }
    
    func moveToProfilesFromFavorites(idx: String) {
        
        guard let profilesVC = profilesViewController else { return }
        let profilesViewModel = ProfilesViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        profilesViewModel.onFollowingButtonTap = { [weak self] in
            self?.moveToFollowings(idx: idx)
        }
        profilesViewModel.onFollowersButtonTap = { [weak self] in
            self?.moveToFollowers(idx: idx)
        }
        profilesVC.viewModel = profilesViewModel
        favoritesWrapper?.pushViewController(profilesVC, animated: false)
    }
    
    func moveToFollowings(idx: String) {
        guard let followingVC = followingViewController else { return }
        let followingVM = FollowingViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        followingVM.onCellTap = { [weak self] idx in
            self?.moveToProfiles(idx: idx)
        }
        followingVC.viewModel = followingVM
        searchWrapper?.pushViewController(followingVC, animated: true)
    }
    
    func moveToFollowingsFromMyProfile(idx: String) {
        guard let followingVC = followingViewController else { return }
        let followingVM = FollowingViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        followingVM.onCellTap = { [weak self] idx in
            self?.moveToProfilesFromFollowings(idx: idx)
        }
        followingVC.viewModel = followingVM
        myProfileWrapper?.pushViewController(followingVC, animated: true)
    }
    
    func moveToFollowers(idx: String) {
        guard let followersVC = followersViewController else { return }
        let followersVM = FollowersViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        followersVM.onCellTap = { [weak self] idx in
            self?.moveToProfiles(idx: idx)
        }
        followersVC.viewModel = followersVM
        searchWrapper?.pushViewController(followersVC, animated: true)
    }
    
    func moveToFollowersFromMyProfile(idx: String) {
        guard let followersVC = followersViewController else { return }
        let followersVM = FollowersViewModel(idx: idx, databaseService: databaseService as! DatabaseService)
        followersVM.onCellTap = { [weak self] idx in
            self?.moveToProfilesFromFollowings(idx: idx)
        }
        followersVC.viewModel = followersVM
        myProfileWrapper?.pushViewController(followersVC, animated: true)
    }
    
    func moveToMainScreen() { }
    
    private func setupTabBar() {
        presenterVC = UITabBarController()
        guard let main = mainViewController else { return }
        let viewModel = MainViewModel(databaseService: databaseService as! DatabaseService)
        onSuccessfullPost = {
            main.checkIfChanged()
        }
        onSuccessfullUnfavorite = {
            main.checkIfChanged()
        }
        onSuccessfulPostDeletion = {
            main.checkIfChanged()
        }

        viewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromMain()
        }
        viewModel.onAuthorTap = { [weak self] idx in
            self?.moveToProfilesFromMain(idx: idx)
        }
        viewModel.onPostTap = { [weak self] idx in
            self?.moveToPostFromMain(idx: idx)
        }
        viewModel.onEditPostTap = { [weak self] idx in
            self?.moveToEditPostFromMain(idx: idx)
        }
        
        main.viewModel = viewModel
        mainWrapper = UINavigationController(rootViewController: main)
        guard let mw = mainWrapper else { return }
        main.tabBarItem.image = UIImage.mainFeed
        main.tabBarItem.title = "Main Feed"
        
        guard let search = searchViewController else { return }
        let searchViewModel = SearchViewModel(databaseService: databaseService as! DatabaseService)
        searchViewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromSearch()
        }
        searchViewModel.onCellTap = { [weak self] idx in
            self?.moveToProfiles(idx: idx)
        }
        search.viewModel = searchViewModel
        searchWrapper = UINavigationController(rootViewController: search)
        guard let sw = searchWrapper else { return }
        search.tabBarItem.image = UIImage.search
        search.tabBarItem.title = "Search"
        
        guard let favorites = favoritesViewController else { return }
        let favoritesViewModel = FavoritesViewModel(databaseService: databaseService  as! DatabaseService)
        
        favoritesViewModel.onCreatePostTap = { [weak self] in
            self?.moveToCreatePostFromFavorites()
        }
        favoritesViewModel.onAuthorTap = { [weak self] idx in
            self?.moveToProfilesFromFavorites(idx: idx)
        }
        favoritesViewModel.onUnfavoriteButtonTap = { [weak self] in
            self?.onSuccessfullUnfavorite?()
        }
        favoritesViewModel.onPostTap = { [weak self] idx in
            self?.moveToPostFromFavorites(idx: idx)
        }
        favorites.viewModel = favoritesViewModel
        favoritesWrapper = UINavigationController(rootViewController: favorites)
        guard let fw = favoritesWrapper else { return }
        favorites.tabBarItem.image = UIImage.favoriteFeed
        favorites.tabBarItem.title = "Favorites"
        
        guard let profile = myProfileViewController else { return }
        let myProfileViewModel = MyProfileViewModel(databaseService: databaseService as! DatabaseService)
        onSuccessfulProfileEdit = {
            profile.fetchUserInfo()
        }
        
        myProfileViewModel.onEditProfileTap = { [weak self] in
            self?.moveToEditProfile()
        }
        myProfileViewModel.onSignOutTap = { [weak self] in
            self?.onSignOutCompletion?()
        }
        myProfileViewModel.onFollowingButtonTap = { [weak self] idx in
            self?.moveToFollowingsFromMyProfile(idx: idx)
        }
        myProfileViewModel.onFollowersButtonTap = { [weak self] idx in
            self?.moveToFollowersFromMyProfile(idx: idx)
        }
        myProfileViewModel.onPostTap = { [weak self] idx in
            self?.moveToPostFromMyProfile(idx: idx)
        }
        myProfileViewModel.onEditPostTap = { [weak self] idx in
            self?.moveToEditPostFromMyProfile(idx: idx)
        }
        profile.viewModel = myProfileViewModel
        myProfileWrapper = UINavigationController(rootViewController: profile)
        guard let pw = myProfileWrapper else { return }
        profile.tabBarItem.image = UIImage.profile
        profile.tabBarItem.title = "My Profile"
        
        presenterVC?.viewControllers = [mw, sw, fw, pw]
    }
}

extension MainFlow {
    fileprivate var mainViewController: MainViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(MainViewController.self)) as? MainViewController
    }
    fileprivate var searchViewController: SearchViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(SearchViewController.self)) as? SearchViewController
    }
    fileprivate var favoritesViewController: FavoritesViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(FavoritesViewController.self)) as? FavoritesViewController
    }
    fileprivate var myProfileViewController: MyProfileViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(MyProfileViewController.self)) as? MyProfileViewController
    }
    fileprivate var profilesViewController: ProfilesViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(ProfilesViewController.self)) as? ProfilesViewController
    }
    fileprivate var createPostViewController: CreatePostViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(CreatePostViewController.self)) as? CreatePostViewController
    }
    fileprivate var followingViewController: FollowingViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(FollowingViewController.self)) as? FollowingViewController
    }
    fileprivate var followersViewController: FollowersViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(FollowersViewController.self)) as? FollowersViewController
    }
    fileprivate var editProfileViewController: EditProfileViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(EditProfileViewController.self)) as? EditProfileViewController
    }
    fileprivate var editPostViewController: EditPostViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(EditPostViewController.self)) as? EditPostViewController
    }
    fileprivate var deleteAccViewController: DeleteAccViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(DeleteAccViewController.self)) as? DeleteAccViewController
    }
    fileprivate var postViewController: PostViewController? {
        return mainSB.instantiateViewController(withIdentifier: String.className(PostViewController.self)) as? PostViewController
    }
}

