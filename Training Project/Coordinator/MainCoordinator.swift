//
//  MainCoordinator.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//


import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//                let mainVC = MainViewController()
//                mainVC.coordinator = self
//                navigationController.pushViewController(mainVC, animated: false)
        
        let productVC = ProductsViewController()
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: false)
        
    }
    
    func showProductsScreen() {
        let productsScreen = ProductsViewController()
        navigationController.pushViewController(productsScreen, animated: true)
    }
    
    func showProductDetail(with product: Product) {
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = product
        navigationController
            .pushViewController(productDetailVC, animated: true)
    }
    
    func presentCreateProduct(from viewController: UIViewController, onSave: @escaping (Product) -> Void) {
        presentProductForm(mode: .create, onSave: onSave)
    }
    
    func presentEditProduct(_ product: Product, onSave: @escaping (Product) -> Void) {
        presentProductForm(mode: .edit(product), onSave: onSave)
    }
    
    private func presentProductForm(mode: ProductFormViewController.Mode, onSave: @escaping (Product) -> Void) {
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
