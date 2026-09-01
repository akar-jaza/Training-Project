//
//  ProductsScreen.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit

class ProductsViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    private let viewModel = ProductsViewModel()
    private let productViewItem = ProductViewItem()
    private let productsView = ProductsView()
    
    
    override func loadView() {
        view = productsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        
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

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductViewCell.reuseID, for: indexPath) as? ProductViewCell else {
            return UITableViewCell()
        }
        
        let product = viewModel.products[indexPath.row]
        cell.configure(title: product.title, description: product.description, image: UIImage(systemName: "shippingbox.fill"))
        
        
        ImageLoader.shared
            .loadImage(from: product.thumbnail) { [weak cell] image in
                
                cell?.productImage.image = image
            }
        
        return cell
    }
}

extension ProductsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let product = viewModel.products[indexPath.row]
        coordinator?.goToProductItemView(with: product)
    }
}
