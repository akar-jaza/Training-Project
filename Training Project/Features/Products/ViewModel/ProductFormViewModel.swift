//
//  ProductFormViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/2/26.
//

import Foundation
import RxSwift

class ProductFormViewModel {
    var onSuccess: ((Product) -> Void)?
    var onError: ((Error) -> Void)?
    var networkService: NetworkServiceProtocol = NetworkService.shared
    var disposeBag = DisposeBag()
    
    func createProduct(title: String, description: String, price: Double) {
        guard let url = URL(string: "https://dummyjson.com/products/add") else { return }
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "price": price
        ]
        networkService.request(url: url, method: .post, body: body)
            .subscribe(onNext: { [weak self] (response: CreateProductResponse) in
                let newProduct = Product(
                    id: response.id,
                    title: title,
                    description: description,
                    price: price,
                    thumbnail: ""
                )
                DispatchQueue.main.async {
                    self?.onSuccess?(newProduct)
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async { self?.onError?(error) }
            })
            .disposed(by: disposeBag)
    }
    
    func updateProduct(id: Int, title: String, description: String, price: Double, currentThumbnail: String) {
        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else { return }
        let body: [String: Any] = [
            "title": title,
            "description": description,
            "price": price
        ]
        networkService.request(url: url, method: .put, body: body)
            .subscribe(onNext: { [weak self] (response: CreateProductResponse) in
                let updatedProduct = Product(
                    id: id,
                    title: title,
                    description: description,
                    price: price,
                    thumbnail: currentThumbnail,
                )
                
                DispatchQueue.main.async {
                    self?.onSuccess?(updatedProduct)
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async { self?.onError?(error) }
            })
            .disposed(by: disposeBag)
    }
}



