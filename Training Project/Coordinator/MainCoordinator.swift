//
//  MainCoordinator.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController {
        tabBarController.selectedViewController as! UINavigationController
    }
    
    let tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        guard let navControllers = tabBarController.viewControllers as? [UINavigationController] else { return }
        
        for nav in navControllers {
            if let homeVC = nav.viewControllers.first as? HomeViewController {
                homeVC.coordinator = self
            }
            if let profileVC = nav.viewControllers.first as? ProfileViewController {
                profileVC.coordinator = self
            }
        }
    }
}

// MARK: - Products Navigation

extension MainCoordinator {
    
    func showProductsScreen() {
        let productsScreen = ProductsViewController()
        productsScreen.coordinator = self 
        navigationController.pushViewController(productsScreen, animated: true)
    }
    
    func showProductDetail(with product: Product) {
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = product
        
        navigationController.pushViewController(
            productDetailVC,
            animated: true
        )
    }
}

// MARK: - Product Form Navigation

extension MainCoordinator {
    
    func presentCreateProduct(
        from viewController: UIViewController,
        onSave: @escaping (Product) -> Void
    ) {
        presentProductForm(mode: .create, onSave: onSave)
    }
    
    func presentEditProduct(
        _ product: Product,
        onSave: @escaping (Product) -> Void
    ) {
        presentProductForm(mode: .edit(product), onSave: onSave)
    }
    
    private func presentProductForm(
        mode: ProductFormViewController.Mode,
        onSave: @escaping (Product) -> Void
    ) {
        let formVC = ProductFormViewController(mode: mode)
        formVC.coordinator = self
        formVC.onSave = onSave
        
        let navWrapper = UINavigationController(rootViewController: formVC)
        
        if let sheet = navWrapper.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        navigationController.present(navWrapper, animated: true)
    }
}
// MARK: - RxSwift Screen Navigation

extension MainCoordinator {
    func showRxSwiftPage() {
        let rxSwiftScreen = RxProductViewController()
        rxSwiftScreen.coordinator = self
        navigationController.pushViewController(rxSwiftScreen, animated: true)
    }
}
