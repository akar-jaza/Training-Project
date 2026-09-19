import Foundation
import RxSwift
import RxCocoa

final class RxProductViewModel {
    var items = PublishSubject<[RxProduct]>()
    
    func fetchItems() {
        let
        products = [
            RxProduct(imageName: "house", title: "Home"),
            RxProduct(imageName: "gear", title: "Settings"),
            RxProduct(imageName: "person circle", title: "Profile"),
            RxProduct(imageName: "airplane", title: "Flights"),
            RxProduct(imageName: "bell", title: "Activity"),
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}
