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
        
        var content = cell.defaultContentConfiguration()
        let product = viewModel.products[indexPath.row]
        
        content.text = product.title
        content.secondaryText = product.description
        content.image = UIImage(systemName: "shippingbox.fill")
        cell.contentConfiguration = content
        
        ImageLoader.shared
            .loadImage(from: product.thumbnail) { [weak cell] image in
                
                var updatedContent = cell?.defaultContentConfiguration()
                updatedContent?.text = product.title
                updatedContent?.secondaryText = product.description
                updatedContent?.image = image
                updatedContent?.imageProperties.maximumSize = CGSize(width: 50, height: 50)
                cell?.contentConfiguration = updatedContent
            }
        
        return cell
    }
}
