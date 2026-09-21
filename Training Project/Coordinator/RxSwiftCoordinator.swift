import UIKit

class RxSwiftCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let RxSwiftVC = RxProductViewController()
        RxSwiftVC.coordinator = self
        RxSwiftVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(RxSwiftVC, animated: true)
    }
}
