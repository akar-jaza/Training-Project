import Testing
import RxSwift
@testable import Training_Project

struct ProductViewModelTests {

    @Test func fetchProducts_onSuccess_updatesProductsAndCache() {
        let mockNetwork = MockNetworkService()
        let mockCache = MockDataCacheService()

        let fakeProducts = [
            Product(id: 1, title: "Test Product", description: "desc", price: 9.99, thumbnail: "")
        ]
        mockNetwork.result = .success(ProductsResponse(products: fakeProducts))

        let viewModel = ProductViewModel(networkService: mockNetwork, cacheService: mockCache)

        var receivedProducts: [Product] = []
        let disposeBag = DisposeBag()
        viewModel.products
            .subscribe(onNext: { receivedProducts = $0 }) 
            .disposed(by: disposeBag)

        viewModel.fetchProducts()

        #expect(receivedProducts.count == 1)
        #expect(receivedProducts.first?.title == "Test Product")

        let cached = mockCache.load([Product].self, forKey: "cached_products")
        #expect(cached?.count == 1)
    }

    @Test func fetchProducts_onFailure_tellsDelegate() {
        let mockNetwork = MockNetworkService()
        mockNetwork.result = .failure(NetworkError.noData)

        let delegate = MockProductsViewModelDelegate()
        let viewModel = ProductViewModel(networkService: mockNetwork, cacheService: MockDataCacheService())
        viewModel.delegate = delegate as? any ProductsViewModelDelegate

        viewModel.fetchProducts()

        #expect(delegate.didError != nil)
    }
}
