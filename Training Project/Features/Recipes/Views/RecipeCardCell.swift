import UIKit

final class RecipeCardCell: UICollectionViewCell, ViewCode {
    static let reuseID = "RecipeCardCell"
    
    let reciepeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildViewCode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        stack.addArrangedSubview(reciepeImage)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(descriptionLabel)
        contentView.addSubview(stack)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            reciepeImage.topAnchor.constraint(equalTo: stack.topAnchor),
            reciepeImage.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            reciepeImage.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            reciepeImage.widthAnchor.constraint(equalTo: stack.widthAnchor),
            reciepeImage.heightAnchor.constraint(equalToConstant: 100),
            
        ])
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 12
    }
    
    func configure(title: String, description: String, image: UIImage? = UIImage(systemName: "fork.knife")) {
        titleLabel.text = title
        descriptionLabel.text = description
        reciepeImage.image = image
    }
    
    
}
