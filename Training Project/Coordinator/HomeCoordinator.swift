import UIKit

protocol HomeCoordinatorProtocol: AnyObject {
    func showProductsScreen()
    func showRxSwiftPage()
    func showRecipesScreen()
    func showLoginScreen()
}


final class HomeCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let appCoordinator: AppCoordinator
    private var recipeCoordinator: RecipeCoordinator?
    private var rxSwiftCoordinator: RxSwiftCoordinator?
    private var productsCoordinator: ProductCoordinator?

    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    
    func start() {
        let homeVC = HomeViewController()
        homeVC.coordinator = self
        navigationController.viewControllers = [homeVC]
    }
}

extension HomeCoordinator: HomeCoordinatorProtocol {
    func showProductsScreen() {
        let coordinator = ProductCoordinator(
            navigationController: navigationController
        )
        self.productsCoordinator = coordinator
        coordinator.start()
    }
    
    func showRxSwiftPage() {
        let coordinator = RxSwiftCoordinator(
            navigationController: navigationController
        )
        self.rxSwiftCoordinator = coordinator
        coordinator.start()
    }
    
    func showRecipesScreen() {
        let coordinator = RecipeCoordinator(navigationController: navigationController)
        self.recipeCoordinator = coordinator
        coordinator.start()
    }
    
    func showLoginScreen() {
        // I didn't clear the user session previously
        UserSessionService.shared.clear()
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        sceneDelegate.switchToLogin()
    }
}
