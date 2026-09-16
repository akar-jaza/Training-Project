//
//  SceneDelegate.swift
//  Training Project
//
//  Created by Akar jaza on 8/28/26.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        if UserSessionService.shared.isLoggedIn {
            switchToMain()
        } else {
            switchToLogin()
        }
        window?.makeKeyAndVisible()
    }
    
    func switchToMain() {
        let tabBarController = MainTabBarController()
        coordinator = AppCoordinator(tabBarController: tabBarController)
        coordinator?.start()
        
        setRootViewController(tabBarController)
    }
    
    func switchToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        
        setRootViewController(navController)
    }
    
    private func setRootViewController(_ viewController: UIViewController) {
        guard let window = window else { return }
        
        if window.rootViewController != nil {
            UIView.transition(
                with: window,
                duration: 0.35,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = viewController
                }
            )
        } else {
            window.rootViewController = viewController
        }
    }
}
