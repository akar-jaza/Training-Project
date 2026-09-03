//
//  DeleteProductViewModel.swift
//  Training Project
//
//  Created by Akar jaza on 9/3/26.
//

import Foundation

class DeleteProductViewModel {
    var onProductDeleted: ((Product) -> Void)?
    var onError: ((Error) -> Void)?
    
    func deleteProduct(id: Int) {
        guard let url = URL(string: "https://dummyjson.com/products/\(id)") else { return }
        //

    }
}
