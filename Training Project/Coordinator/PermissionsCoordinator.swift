import UIKit

class PermissionsCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let permissionsVC = PermissionsHostingController()
        permissionsVC.coordinator = self
        permissionsVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(permissionsVC, animated: true)
    }
}
