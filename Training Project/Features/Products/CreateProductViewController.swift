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
        
    }
}


// MARK: - Action Buttons
extension CreateProductViewController {
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func addProductTapped() {
        // 
    }
}
