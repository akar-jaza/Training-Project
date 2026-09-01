//
//  ProductsScreen.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit

//MARK: - ProductsViewController
class ProductsViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    private let viewModel = ProductsViewModel()
    private let productDetailView = ProductDetailView()
    private let productsView = ProductsView()
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func loadView() {
        view = productsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        
        setupNavigationBar()
        
        productsView.tableView.dataSource = self
        productsView.tableView.delegate = self
        productsView.tableView
            .register(
                ProductViewCell.self,
                forCellReuseIdentifier: ProductViewCell.reuseID
            )
        
        viewModel.onProductsUpdated = { [weak self] in
            self?.productsView.tableView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Failed to fetch products: \(error)")
        }
        
        viewModel.fetchProducts()
    }
    
    // remove the gray highlight from the cell when we go back to the prev screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = productsView.tableView.indexPathForSelectedRow {
            productsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    
}

// MARK: - UITableViewDataSource
extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCell.reuseID, for: indexPath) as? ProductViewCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell
            .configure(
                title: product.title,
                description: product.description,
                image: UIImage(systemName: "shippingbox.fill")
            )
        
        cell.productImage.tintColor = .systemGray
        
        ImageLoader.shared
            .loadImage(from: product.thumbnail) { [weak cell] image in
                
                cell?.productImage.image = image
            }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.products[indexPath.row]
        coordinator?.showProductDetail(with: product)
    }
}


// MARK: - Button Actions
extension ProductsViewController {
    @objc private func didTapAdd() {
        print("Add product tapped")
    }
}
