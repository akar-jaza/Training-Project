import Foundation
import RxSwift
import RxCocoa
import UIKit

class ProductDetailViewModel {
    private let product: Product
    
    // special casting. Never changs.
    let title: Observable<String>
    let description: Observable<String>
    let priceText: Observable<String>
    
    // this one changes, first stars with a placeholder icon, then network fetches the images.
    private let imageRelay = BehaviorRelay<UIImage?>(value: UIImage(systemName: "shippingbox.fill"))
    var image: Observable<UIImage?> {
        imageRelay.asObservable()
    }
    
    init(product: Product) {
        self.product = product
        self.title = .just(product.title)
        self.description = .just(product.description)
        self.priceText = .just("$\(product.price)")        
        ImageLoader.shared.loadImage(from: product.thumbnail, delegate: self)
        // note;; .just means here is the product price. Give it to whoever subscribes, and it's only once(emits once to the subscribers.).
    }
    
}

extension ProductDetailViewModel: ImageLoaderDelegate {
    func imageLoader(_ loader: ImageLoader, didLoad image: UIImage?, for urlString: String, didFailWithError error: Error?) {
        guard urlString == product.thumbnail, let image = image else { return }
        imageRelay.accept(image)
    }
}
