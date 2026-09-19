import Foundation
import RxSwift

protocol ProductFormViewModelDelegate: AnyObject {
    func didSaveProduct(_ product: Product)
    func didUpdateProduct(_ product: Product)
    func didErrorOccured(error: Error)
}

final class ProductFormViewModel {

    var networkService: NetworkServiceProtocol = NetworkService.shared
    weak var delegate: ProductFormViewModelDelegate?

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
                    self?.delegate?.didSaveProduct(newProduct)
                }
            }, onError: { [weak self] error in
                self?.delegate?.didErrorOccured(error: error)
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
        // The response is a CreateProductResponse, but throw it away; I don't need it.
        networkService.request(url: url, method: .put, body: body)
            .subscribe(onNext: { [weak self] (_: CreateProductResponse) in
                let updatedProduct = Product(
                    id: id,
                    title: title,
                    description: description,
                    price: price,
                    thumbnail: currentThumbnail,
                )
                
                DispatchQueue.main.async {
                    self?.delegate?.didUpdateProduct(updatedProduct)
                }
            }, onError: { [weak self] error in
                DispatchQueue.main.async {
                    self?.delegate?.didErrorOccured(error: error)
                }
            })
            .disposed(by: disposeBag)
    }
}



