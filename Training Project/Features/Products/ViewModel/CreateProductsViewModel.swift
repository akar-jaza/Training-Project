//
//  CreateProductsViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/2/26.
//

import Foundation

class CreateProductsViewModel {
    var onProductCreated: ((Product) -> Void)?
    var onError: ((Error) -> Void)?
    
    func createProduct(title: String, description: String, price: Double) {
        guard let url = URL(string: "https://dummyjson.com/products/add") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "price": price
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            onError?(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                DispatchQueue.main.async { self?.onError?(error) }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(CreateProductResponse.self, from: data)
                
                let newProduct = Product(
                    id: decoded.id,
                    title: title,
                    description: description,
                    price: price,
                    thumbnail: ""
                )
                
                DispatchQueue.main.async {
                    self?.onProductCreated?(newProduct)
                }
            } catch {
                DispatchQueue.main.async { self?.onError?(error) }
            }
            
        }.resume()
        
    }
}
