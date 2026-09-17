import UIKit

final class RecipeCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let reciepeVC = RecipeViewController()
        reciepeVC.coordinator = self
        navigationController.viewControllers = [reciepeVC]
    }

    func showRecipePage() {
        let recipeVC = RecipeViewController()
        recipeVC.coordinator = self
        navigationController.pushViewController(recipeVC, animated: true)
    }
}
