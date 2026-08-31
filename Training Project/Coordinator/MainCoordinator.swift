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
//        let mainVC = MainViewController()
//        mainVC.coordinator = self
//        navigationController.pushViewController(mainVC, animated: false)
        
        let productVC = ProductsViewController()
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: false)
        
//        let productVI = ProductViewItem()
//        productVI.coordinator = self
//        navigationController.pushViewController(productVI, animated: false)
    }

    func showProductsScreen() {
        let productsScreen = ProductsViewController()
        navigationController.pushViewController(productsScreen, animated: true)
    }
    
    func goToProductItemView(with product: Product) {
        let productView = ProductViewItem()
        productView.coordinator = self
        productView.configProductView(Product: product)
        navigationController.pushViewController(productView, animated: true)
    }
    
    /*
     func showDetail(for title: String) {
             let detailVC = DetailViewController()
             detailVC.title = title
             navigationController.pushViewController(detailVC, animated: true)
         }
     */

}
