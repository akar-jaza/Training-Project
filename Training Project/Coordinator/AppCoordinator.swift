import UIKit

final class AppCoordinator: Coordinator {
    
    let tabBarController: UITabBarController
    private var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController {
        tabBarController.selectedViewController as! UINavigationController
    }
    
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        guard let mainTabBarController = tabBarController as? MainTabBarController else { return }
        
        let homeCoordinator = HomeCoordinator(
            navigationController: mainTabBarController.homeNavigationController,
            appCoordinator: self
        )
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
        
        if let profileVC = mainTabBarController.profileNavigationController.viewControllers.first as? ProfileViewController {
            profileVC.coordinator = self
        }
    }
}

// MARK: - Products Navigation

extension AppCoordinator {
    
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

extension AppCoordinator {
    
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
