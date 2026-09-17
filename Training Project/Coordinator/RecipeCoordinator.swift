import UIKit

final class RecipeCoordinator: Coordinator {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let recipeVC = RecipeViewController()
        recipeVC.coordinator = self
        navigationController.pushViewController(recipeVC, animated: true)
    }
}
