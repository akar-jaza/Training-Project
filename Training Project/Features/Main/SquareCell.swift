//
//  SquareCell.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit

class SquareCell: UICollectionViewCell {
    static let reuseID = "SquareCell"
    var onTap: (() -> Void)?
    
    let cellActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        cellActionButton.layer.cornerRadius = 8
        cellActionButton.clipsToBounds = true
        
        cellActionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        contentView.addSubview(cellActionButton)
        
        NSLayoutConstraint.activate([
            cellActionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellActionButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellActionButton.heightAnchor
                .constraint(equalTo: contentView.heightAnchor),
            cellActionButton.widthAnchor
                .constraint(equalTo: contentView.widthAnchor),
        ])
    }
    
    func configure(text: String, indexPath: IndexPath) {
        cellActionButton.setTitle(text, for: .normal)
        
        switch indexPath.item {
        case 0:
            cellActionButton.backgroundColor = .black
        default:
            cellActionButton.backgroundColor = .systemGray
        }
        
    }
    
    @objc
    private func buttonTapped() {
        onTap?()
    }
    
    
}
