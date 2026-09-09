//
//  MainTabBarController.swift
//  Training Project
//
//  Created by Akar jaza on 9/8/26.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let homeViewController = HomeViewController()
        let profileViewController = ProfileViewController()
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle.fill"),
            tag: 1
        )
        
        UITabBar.appearance().tintColor = AppColors.primaryColor
        
        viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: profileViewController)
        ]
    }
}
