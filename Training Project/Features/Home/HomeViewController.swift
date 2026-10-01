import UIKit

final class HomeViewController: UIViewController, ViewCode {
    weak var coordinator: HomeCoordinatorProtocol?
    
    let uiCollectionViewFlowLayout = UICollectionViewFlowLayout()
    let itemsPerRow: CGFloat = 2
    let spacing: CGFloat = 10
    let buttonTitles = ["Products", "RxSwift", "Recipes", "Permissions"]
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: uiCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home"
        
        buildViewCode()
    }
    

}

// MARK: - Action Buttons
extension HomeViewController {
    @objc func logoutTapped() {
        coordinator?.showLoginScreen()
    }
}
