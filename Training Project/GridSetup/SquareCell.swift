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
        backgroundColor = .black
        layer.cornerRadius = 8
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
    
    func configure(text: String) {
        cellActionButton.setTitle(text, for: .normal)
    }
    
    @objc
    private func buttonTapped() {
        onTap?()
    }
    
    
}
