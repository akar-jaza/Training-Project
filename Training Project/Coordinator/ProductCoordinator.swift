import UIKit

class ProductCoordinator: Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let productVC = ProductViewController()
        productVC.coordinator = self
        navigationController.pushViewController(productVC, animated: true)
    }
    
    func showProductDetail(with product: Product) {
        let productDetailVC = ProductDetailViewController()
        productDetailVC.product = product
        
        navigationController.pushViewController(
            productDetailVC,
            animated: true
        )
    }
    
    func presentCreateProduct(
        delegate: ProductFormDelegate
    ) {
        presentProductForm(mode: .create, delegate: delegate)
    }
    
    func presentEditProduct(
        _ product: Product,
        delegate: ProductFormDelegate
    ) {
        presentProductForm(mode: .edit(product), delegate: delegate)
    }
    
    private func presentProductForm(
        mode: ProductFormViewController.Mode,
        delegate: ProductFormDelegate
    ) {
        let formVC = ProductFormViewController(mode: mode)
        formVC.coordinator = self
        formVC.delegate = delegate
        
        let navWrapper = UINavigationController(rootViewController: formVC)
        
        if let sheet = navWrapper.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        navigationController.present(navWrapper, animated: true)
    }
}
