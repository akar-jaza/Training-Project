//
//  ProductViewItem.swift
//  Training Project
//
//  Created by Akar jaza on 8/31/26.
//

import UIKit

class ProductDetailView: UIView, ViewCode {
    weak var coordinator: MainCoordinator?
    
    let productImage: UIImageView = {
        let image = UIImage(systemName: "shippingbox.fill")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let price: UILabel = {
        let price = UILabel()
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    let addToCart: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        buildViewCode()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(productImage)
        contentStack.addArrangedSubview(productTitle)
        contentStack.addArrangedSubview(price)
        contentStack.addArrangedSubview(productDescription)
        
        addSubview(addToCart)
    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addToCart.topAnchor, constant: -16),
            
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            productImage.centerXAnchor.constraint(equalTo: contentStack.centerXAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 220),
            
            addToCart.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            addToCart.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addToCart.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addToCart.heightAnchor.constraint(equalToConstant: 52)
        ])
        
    }

    func configProductView(Product product: Product) {
        productTitle.text = product.title
        productDescription.text = product.description
        price.text = "$\(product.price)"
        
        ImageLoader.shared.loadImage(from: product.thumbnail) { image in
            self.productImage.image = image
        }
    }

}
