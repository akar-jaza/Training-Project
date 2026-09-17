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
        let productsScreen = ProductsViewController()
        productsScreen.coordinator = appCoordinator
        navigationController.pushViewController(productsScreen, animated: true)
    }
    
    func showRxSwiftPage() {
        let rxSwiftScreen = RxProductViewController()
        rxSwiftScreen.coordinator = appCoordinator
        navigationController.pushViewController(rxSwiftScreen, animated: true)
    }
    
    func showRecipesScreen() {
        let coordinator = RecipeCoordinator(navigationController: navigationController)
        self.recipeCoordinator = coordinator
        coordinator.showRecipePage()
    }
    
    func showLoginScreen() {
        // I didn't clear the user session previously
        UserSessionService.shared.clear()
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        sceneDelegate.switchToLogin()
    }
}
