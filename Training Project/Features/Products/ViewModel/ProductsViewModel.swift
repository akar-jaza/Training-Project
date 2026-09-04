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
    
    func deleteProduct(_ product: Product, at index: Int) {
        guard let url = URL(string: "https://dummyjson.com/products/\(product.id)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                DispatchQueue.main.async { self?.onError?(error) }
                return
            }
            
            // Dummy json won't delete it on their server because DummyJson server doesn't exist, we remove it locally either way. THis func is just for learning purposes
            DispatchQueue.main.async {
                guard self?.products.indices.contains(index) == true else { return }
                self?.products.remove(at: index)
                self?.onProductsUpdated?()
            }
            
        }.resume()
    }

    
    func addProduct(_ product: Product) {
        products.insert(product, at: 0)
        onProductsUpdated?() 
    }
}
