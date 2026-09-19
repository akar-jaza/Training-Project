import UIKit
import RxSwift
import RxCocoa

final class LoadingButton: UIButton, ViewCode {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private var originalTitle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildViewCode()
    }
    
    func setupHierarchy() {
        addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
    func showLoading() {
        originalTitle = title(for: .normal)
        setTitle("", for: .normal)
        isEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        if let originalTitle = originalTitle {
            setTitle(originalTitle, for: .normal)
        }
        isEnabled = true
        activityIndicator.stopAnimating()
    }
}


extension Reactive where Base: LoadingButton{
    
    var isLoading: Binder<Bool> {
        return Binder(self.base) { button, isLoading in
            if isLoading {
                button.showLoading()
            } else {
                button.hideLoading()
            }
        }
    }
}
