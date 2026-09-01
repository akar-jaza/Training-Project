//
//  ProductDetailViewController.swift
//  Training Project
//
//  Created by Akar jaza on 9/1/26.
//

import UIKit

class ProductDetailViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    private let productDetailView = ProductDetailView()

    var product: Product?

    override func loadView() {
        view = productDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // productDetailView.coordinator = coordinator

        if let product = product {
            productDetailView.configProductView(Product: product)
        }

        productDetailView.addToCart.addTarget(
            self,
            action: #selector(addToCartTapped),
            for: .touchUpInside
        )
    }

    @objc private func addToCartTapped() {
        print("Add to cart tapped for: \(product?.title ?? "unknown")")
    }
}
