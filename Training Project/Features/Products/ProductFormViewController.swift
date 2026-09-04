//
//  CreateProductViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/1/26.
//

import UIKit

class ProductFormViewController: UIViewController {
    
    enum Mode {
        case create
        case edit(Product)
    }
    
    weak var coordinator: MainCoordinator?
    
    private let productFormView = ProductFormView()
    private let viewModel = ProductFormViewModel()
    
    private let mode: Mode
    
    var onSave: ((Product) -> Void)?
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = productFormView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForMode()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        
        
        viewModel.onSuccess = { [weak self] product in
            self?.onSave?(product)
            self?.dismiss(animated: true)
        }
        
        viewModel.onError = { error in
            print("Failed to create product: \(error)")
        }
        
        productFormView.titleField.delegate = self
        productFormView.descriptionField.delegate = self
        productFormView.priceField.delegate = self
        
        // dismissing the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    private func configureForMode() {
        switch mode {
        case .create:
            title = "New Product"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add, target: self, action: #selector(saveTapped)
            )
        case .edit(let product):
            title = "Edit Product"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(
                    saveTapped
                )
            )
            
            productFormView.titleField.text = product.title
            productFormView.descriptionField.text = product.description
            productFormView.priceField.text = "\(product.price)"
        }
        navigationItem.rightBarButtonItem?.style = .prominent
    }
}


// MARK: - Action Buttons
extension ProductFormViewController {
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveTapped() {
        let title = productFormView.titleField.text ?? ""
        let description = productFormView.descriptionField.text ?? ""
        let priceText = productFormView.priceField.text ?? ""
        
        guard !title.isEmpty, !description.isEmpty, let price = Double(priceText) else {
            print("Missing or invalid fields")
            return
        }
        
        switch mode {
        case .create:
            viewModel.createProduct(title: title, description: description, price: price)
            
        case .edit(let originalProduct):
            viewModel.updateProduct(
                id: originalProduct.id,
                title: title,
                description: description,
                price: price,
                currentThumbnail: originalProduct.thumbnail,
            )
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProductFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case productFormView.titleField:
            productFormView.descriptionField.becomeFirstResponder()
        case productFormView.descriptionField:
            productFormView.priceField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}

