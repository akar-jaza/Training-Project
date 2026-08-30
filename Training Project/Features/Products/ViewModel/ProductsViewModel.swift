//
//  ProductsViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 8/30/26.
//

import Foundation


class ProductsViewModel {
    private(set) var products: [Product] = []
    
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    func fetchProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                self?.onError?(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(ProductsResponse.self, from: data)
                self?.products = decoded.products
                DispatchQueue.main.async {
                    self?.onProductsUpdated?()
                }
            } catch {
                self?.onError?(error)
            }
        }.resume()
    }
}
