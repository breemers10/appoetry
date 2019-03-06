//
//  AppDelegate.swift
//  appoetry1
//
//  Created by Kristaps Brēmers on 25.02.19.
//  Copyright © 2019. g. Chili. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var rootWindow: UIWindow!
    private var appFlow: AppFlow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
    
        rootWindow = UIWindow()
        
        appFlow = AppFlow(with: rootWindow)
        appFlow.start()
////        
//        UITabBarItem.appearance().badgeColor = .green
////
//        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 0/255, blue: 255/255, alpha: 1.0)
//        UITabBar.appearance().barTintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
//        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1.0)
////
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
     
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
}
