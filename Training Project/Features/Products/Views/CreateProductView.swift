//
//  CreateProductView.swift
//  Training Project
//
//  Created by Akar jaza on 9/1/26.
//

import UIKit

class CreateProductView: UIView, ViewCode {
    
    let titleField: UITextField = {
        let field = UITextField()
        
        let placeholder = NSAttributedString(
            string: "Title",
            attributes: [.foregroundColor: UIColor.gray])
        
        field.attributedPlaceholder = placeholder
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let descriptionField: UITextField = {
        let field = UITextField()
        
        let placeholder = NSAttributedString(
            string: "Description",
            attributes: [.foregroundColor: UIColor.gray])
        
        field.attributedPlaceholder = placeholder
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let priceField: UITextField = {
        let field = UITextField()
        
        let placeholder = NSAttributedString(
            string: "Price",
            attributes: [.foregroundColor: UIColor.gray])
        
        field.attributedPlaceholder = placeholder
        field.borderStyle = .roundedRect
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    func setupHierarchy() {
        addSubview(contentStack)
        
        contentStack.addArrangedSubview(titleField)
        contentStack.addArrangedSubview(descriptionField)
        contentStack.addArrangedSubview(priceField)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleField.heightAnchor.constraint(equalToConstant: 44),
            descriptionField.heightAnchor.constraint(equalToConstant: 44),
            priceField.heightAnchor.constraint(equalToConstant: 44),
        ])
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
