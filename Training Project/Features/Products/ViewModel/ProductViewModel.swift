import Foundation
import RxSwift
import RxCocoa

protocol ProductsViewModelDelegate: AnyObject {
    func didErrorOccurr(error: Error)
}

final class ProductViewModel {
    
    // Only this VM can put new values in. Everyone else just watches/reads.
    private let productsRelay = BehaviorRelay<[Product]>(value: [])
    var products: Observable<[Product]> {
        productsRelay.asObservable()
    }
    
    // For places that need the list rn, like when tapping or deleting smth.
    var currentProducts: [Product] {
        productsRelay.value
    }
    
    weak var delegate: ProductsViewModelDelegate?
    var networkService: NetworkServiceProtocol = NetworkService.shared
    var disposeBag = DisposeBag()
    
    func fetchProducts() {
        guard let url = URL(string: "https://dummyjson.com/products") else { return }
        
        networkService.request(url: url, method: .get)
            .subscribe(onNext: { [weak self] (response: ProductsResponse) in
                self?.productsRelay.accept(response.products)
                
            }, onError: { [weak self] error in
                self?.delegate?.didErrorOccurr(error: error)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    func deleteProduct(_ product: Product, at index: Int) {
        guard let url = URL(string: "https://dummyjson.com/products/\(product.id)") else { return }
        
        networkService.requestData(url: url, method: .delete).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard self.currentProducts.indices.contains(index) else {
                    return
                }
                var updatedProducts = self.productsRelay.value
                updatedProducts.remove(at: index)
                
                self.productsRelay.accept(updatedProducts)
            }
        }, onError: { error in
            DispatchQueue.main.async {
                self.delegate?.didErrorOccurr(error: error)
            }
        }).disposed(by: disposeBag)
    }
    
    func addProduct(_ product: Product) {
        var pr = productsRelay.value
        pr.insert(product, at: 0)
        productsRelay.accept(pr)
    }
    
    func updateProduct(_ product: Product) {
        var pr = productsRelay.value
        guard let index = pr.firstIndex(where: { $0.id == product.id }) else { return }  // $0.id == product.id is a closure that checks if the id of the product is equal to the id of the product in the array
        pr[index] = product
        productsRelay.accept(pr)
    }
}
