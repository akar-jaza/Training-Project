//
//  CreateProductViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/1/26.
//

import UIKit

class CreateProductViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private let createProductView = CreateProductView()
    private let viewModel = CreateProductsViewModel()
    
    var onProductCreated: ((Product) -> Void)?
    
    override func loadView() {
        view = createProductView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Product"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProductTapped)
        )
        
        navigationItem.rightBarButtonItem?.style = .prominent
        
        viewModel.onProductCreated = { [weak self] product in
            self?.onProductCreated?(product)
            self?.dismiss(animated: true)
        }
        
        viewModel.onError = { error in
            print("Failed to create product: \(error)")
        }
        
        createProductView.titleField.delegate = self
        createProductView.descriptionField.delegate = self
        createProductView.priceField.delegate = self
        
        // dismissing the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
}


// MARK: - Action Buttons
extension CreateProductViewController {
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addProductTapped() {
        let title = createProductView.titleField.text ?? ""
        let description = createProductView.descriptionField.text ?? ""
        let priceText = createProductView.priceField.text ?? ""
        
        guard !title.isEmpty, !description.isEmpty, let price = Double(priceText) else {
            print("Missing or invalid fields")
            return
        }
        
//        print("New product: \(title), \(description), $\(price)")
        viewModel.createProduct(title: title, description: description, price: price)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreateProductViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case createProductView.titleField:
            createProductView.descriptionField.becomeFirstResponder()
        case createProductView.descriptionField:
            createProductView.priceField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

