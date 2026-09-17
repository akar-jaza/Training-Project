//
//  ProductsViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 8/30/26.
//

import Foundation
import RxSwift

final class ProductsViewModel {
    private(set) var products: [Product] = []
    var networkService: NetworkServiceProtocol = NetworkService.shared
    
    var onProductsUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var disposeBag = DisposeBag()
    
    func fetchProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        networkService.request(url: url, method: .get)
            .subscribe(onNext: { [weak self] (response: ProductsResponse) in
                self?.products = response.products
                self?.onProductsUpdated?()
            }, onError: { [weak self] error in
                self?.onError?(error)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func deleteProduct(_ product: Product, at index: Int) {
        guard let url = URL(string: "https://dummyjson.com/products/\(product.id)") else { return }
        
        networkService.requestData(url: url, method: .delete).subscribe(onNext: { [weak self] data in
            DispatchQueue.main.async {
                guard self?.products.indices.contains(index) == true else { return }
                self?.products.remove(at: index)
                self?.onProductsUpdated?()
            }
        }, onError: { [weak self] error in
            DispatchQueue.main.async {
                self?.onError?(error)
            }
        }).disposed(by: disposeBag)
    }
        
    func addProduct(_ product: Product) {
        products.insert(product, at: 0)
        onProductsUpdated?()
    }
    
    func replaceProduct(_ product: Product, at index: Int) {
        guard products.indices.contains(index) else { return }
        products[index] = product
        onProductsUpdated?()
    }
}
