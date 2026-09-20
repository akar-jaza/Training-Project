import UIKit

final class ProfileViewController: UIViewController, ViewCode {
    weak var coordinator: AppCoordinator?
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Soon..."
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    func setupHierarchy() {
        view.addSubview(label)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        buildViewCode()
    }
    
}
