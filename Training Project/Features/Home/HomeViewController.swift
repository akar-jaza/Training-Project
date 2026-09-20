import UIKit

final class HomeViewController: UIViewController, ViewCode {
    weak var coordinator: HomeCoordinatorProtocol?
    
    let uiCollectionViewFlowLayout = UICollectionViewFlowLayout()
    let itemsPerRow: CGFloat = 2
    let spacing: CGFloat = 10
    let buttonTitles = ["Products", "RxSwift", "Recipes", "Item 4"]
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: uiCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.text = "Home"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBarItem()
        
        buildViewCode()
    }
    
    private func setupNavigationBarItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem?.style = .plain
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "iphone.and.arrow.right.outward"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .red
        
    }
}

// MARK: - Action Buttons
extension HomeViewController {
    @objc func logoutTapped() {
        coordinator?.showLoginScreen()
    }
}
