import UIKit
import RxSwift
import RxCocoa

final class ProductDetailViewController: UIViewController {

    weak var coordinator: ProductCoordinator?

    private let productDetailView = ProductDetailView()
    private var viewModel: ProductDetailViewModel?
    private let disposeBag = DisposeBag()

    var product: Product?

    override func loadView() {
        view = productDetailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let product = product {
            viewModel = ProductDetailViewModel(product: product)
            bindViewModel()
        }

        productDetailView.addToCart.addTarget(
            self,
            action: #selector(addToCartTapped),
            for: .touchUpInside
        )
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        
        viewModel.title
            .bind(to: productDetailView.productTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind(to: productDetailView.productDescription.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.priceText
            .bind(to: productDetailView.price.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.image
            .observe(on: MainScheduler.instance)
            .bind(to: productDetailView.productImage.rx.image)
            .disposed(by: disposeBag)
    }

    @objc private func addToCartTapped() {
        print("Add to cart tapped for: \(product?.title ?? "unknown")")
    }
}
