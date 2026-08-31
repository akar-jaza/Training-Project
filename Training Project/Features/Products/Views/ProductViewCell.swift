//
//  ProductViewCell.swift
//  Training Project
//
//  Created by Akar jaza on 8/31/26.
//

import UIKit

class ProductViewCell: UITableViewCell, ViewCode {
    
    static let reuseID = "ProductCell"
    
    let productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let productTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // chevron
    let chevron: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        contentView.addSubview(productImage)
        contentView.addSubview(productTitle)
        contentView.addSubview(productDescription)
        contentView.addSubview(chevron)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            productImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            productImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImage.widthAnchor.constraint(equalToConstant: 50),
            productImage.heightAnchor.constraint(equalToConstant: 50),
            
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 20),
            
            productTitle.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 12),
            productTitle.trailingAnchor.constraint(equalTo: chevron.leadingAnchor, constant: -12),
            productTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            productDescription.leadingAnchor.constraint(equalTo: productTitle.leadingAnchor),
            productDescription.trailingAnchor.constraint(equalTo: productTitle.trailingAnchor),
            productDescription.topAnchor.constraint(equalTo: productTitle.bottomAnchor, constant: 4),
            productDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        
    }
    
    func configure(title: String, description: String, image: UIImage?) {
        productTitle.text = title
        productDescription.text = description
        productImage.image = image
    }
}
