import UIKit

final class SquareCell: UICollectionViewCell, ViewCode {
    
    static let reuseID = "SquareCell"
    var onTap: (() -> Void)?
    
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let darkOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cellActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        contentView.addSubview(cellActionButton)
        cellActionButton.addSubview(backgroundImageView)
        cellActionButton.addSubview(darkOverlayView)
        cellActionButton.sendSubviewToBack(darkOverlayView)
        cellActionButton.sendSubviewToBack(backgroundImageView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            cellActionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellActionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellActionButton.heightAnchor
                .constraint(equalTo: contentView.heightAnchor),
            cellActionButton.widthAnchor
                .constraint(equalTo: contentView.widthAnchor),
            
            backgroundImageView.topAnchor.constraint(equalTo: cellActionButton.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: cellActionButton.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: cellActionButton.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: cellActionButton.trailingAnchor),
            
            darkOverlayView.topAnchor.constraint(equalTo: cellActionButton.topAnchor),
            darkOverlayView.bottomAnchor.constraint(equalTo: cellActionButton.bottomAnchor),
            darkOverlayView.leadingAnchor.constraint(equalTo: cellActionButton.leadingAnchor),
            darkOverlayView.trailingAnchor.constraint(equalTo: cellActionButton.trailingAnchor),
        ])
    }
    
    func setupAdditionalConfiguration() {
        cellActionButton.layer.cornerRadius = 8
        cellActionButton.clipsToBounds = true

        
        cellActionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    
    func configure(text: String, indexPath: IndexPath) {
        cellActionButton.setTitle(text, for: .normal)
        
        switch indexPath.item {
        case 0:
            backgroundImageView.image = UIImage(named: "productsBackground")
        case 1:
            backgroundImageView.image = UIImage(named: "rxswiftLogo")
        case 2:
            backgroundImageView.image = UIImage(named: "recipesBackground")
            cellActionButton.titleLabel?.textColor = .black
        default:
            cellActionButton.backgroundColor = .systemGray
        }
        
    }
    
    @objc
    private func buttonTapped() {
        onTap?()
    }
    
    
}
