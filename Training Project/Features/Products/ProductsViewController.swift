//
//  ProductsScreen.swift
//  Training Project
//
//  Created by Akar jaza on 8/29/26.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductsViewController: UIViewController {
    
    weak var coordinator: ProductCoordinator?
    private let viewModel = ProductViewModel()
    private let productDetailView = ProductDetailView()
    private let productsView = ProductsView()
    private let disposeBag = DisposeBag()
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.rightBarButtonItem?.style = .prominent
        navigationItem.rightBarButtonItem?.tintColor = AppColors.primaryColor
    }
    
    override func loadView() {
        view = productsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        
        setupNavigationBar()
        
        viewModel.delegate = self
        productsView.tableView.delegate = self
        
        productsView.tableView
            .register(
                ProductViewCell.self,
                forCellReuseIdentifier: ProductViewCell.reuseID
            )
        bindTableView()
        
        viewModel.fetchProducts()
    }
    
    // remove the gray highlight from the cell when we go back to the prev screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = productsView.tableView.indexPathForSelectedRow {
            productsView.tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - Bindings
    private func bindTableView() {
        viewModel.products
            .bind(to: productsView.tableView.rx.items(
                cellIdentifier: ProductViewCell.reuseID,
                cellType: ProductViewCell.self
            )) { _, product, cell in
                cell.configure(
                    title: product.title,
                    description: product.description,
                    image: UIImage(systemName: "shippingbox.fill")
                )
                cell.productImage.tintColor = .systemGray
        
                
                ImageLoader.shared.loadImage(from: product.thumbnail) { [weak cell] image in
                    cell?.productImage.image = image
                }
                
            }
            .disposed(by: disposeBag)
        
        productsView.tableView.rx
            .modelSelected(Product.self)
            .subscribe(onNext: { [weak self] product in
                self?.coordinator?.showProductDetail(with: product)
            })
            .disposed(by: disposeBag)
    }

}


// MARK: - ProductsViewModelDelegate
extension ProductsViewController: ProductsViewModelDelegate {
    func didErrorOccurred(error: Error) {
        showAlert(title: "Error", message: "Something went wrong loading products.")
    }
}



// MARK: - Button Actions
extension ProductsViewController {
    @objc private func didTapAdd() {
        //        coordinator?
        //            .presentCreateProduct(from: self) { [weak self] newProduct in
        //            self?.productsViewModel.addProduct(newProduct)
        //        }
    }
}

// MARK: - Context menu on long press
extension ProductsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let identifier = indexPath as NSIndexPath
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: {
                return nil
            },
            actionProvider: { _ in
                let editAction = UIAction(
                    title: "Edit",
                    image: UIImage(systemName: "pencil"),
                    identifier: UIAction.Identifier("edit"),
                    handler: {
                        [weak self] _ in
                        guard let self = self else { return }
                        let product = viewModel.currentProducts[indexPath.row]
                        
//                        self.coordinator?.presentEditProduct(product) { [weak self] updatedProduct in
//                            self?.productsViewModel.replaceProduct(updatedProduct, at: indexPath.row)
//                        }
                    }
                )
                
                let deleteAction = UIAction(
                    title: "Delete",
                    image: UIImage(systemName: "trash"),
                    identifier: UIAction.Identifier("delete"),
                    attributes: .destructive,
                    handler: {
                        [weak self] _ in
                        guard let self = self else { return }
//                        let product = self.productsViewModel.products[indexPath.row]
                        let product = viewModel.currentProducts[indexPath.row]
                        viewModel.deleteProduct(product, at: indexPath.row)
                    }
                )
                
                return UIMenu(title: "", children: [editAction, deleteAction])
            }
        )
    }
}
