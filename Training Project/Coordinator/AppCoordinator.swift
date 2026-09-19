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

