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
    private let productsView = ProductsView()
    
    override func loadView() {
        view = productsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        
        productsView.tableView.dataSource = self
        productsView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        
        viewModel.onProductsUpdated = { [weak self] in
            self?.productsView.tableView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Failed to fetch products: \(error)")
        }
        
        viewModel.fetchProducts()
    }
}

extension ProductsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = viewModel.products[indexPath.row]
        cell.textLabel?.text = product.title
        cell.detailTextLabel?.text = "$\(product.price)"
        return cell
    }
}
