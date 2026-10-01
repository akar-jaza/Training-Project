import Testing
import Foundation
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
    
    @Test func deleteProduct_onSuccess_removesFromListAndCache() {
        let mockNetwork = MockNetworkService()
        let mockCache = MockDataCacheService()
        let viewModel = ProductViewModel(networkService: mockNetwork, cacheService: mockCache)
        
        let productToDelete = Product(id: 1, title: "Delete Me", description: "", price: 1, thumbnail: "")
        let otherProduct = Product(id: 2, title: "Keep Me", description: "", price: 2, thumbnail: "")
        
        // Seed the list the same way a real screen would: fetch first.
        mockNetwork.result = .success(ProductsResponse(products: [productToDelete, otherProduct]))
        viewModel.fetchProducts()
        
        // Now simulate a successful DELETE response
        mockNetwork.result = .success(Data())
        viewModel.deleteProduct(productToDelete, at: 0)
        
        #expect(viewModel.currentProducts.count == 1) // only one product should remain
        #expect(viewModel.currentProducts.first?.id == 2) // and that product's ID is 2
        
        let cached = mockCache.load([Product].self, forKey: "cached_products")
        #expect(cached?.count == 1)
    }
    
    @Test func updateProduct_withExistingID_replacesProductInListAndCache() {
        let mockNetwork = MockNetworkService()
        let mockCache = MockDataCacheService()
        let viewModel = ProductViewModel(networkService: mockNetwork, cacheService: mockCache)
        
        let originalProduct = Product(id: 1, title: "Original Product", description: "", price: 2, thumbnail: "")
        let updatedProduct = Product(id: 1, title: "Updated Product", description: "", price: 12, thumbnail: "")
        
        mockNetwork.result = .success(ProductsResponse(products: [originalProduct]))
        viewModel.fetchProducts()
        
        let cachedBefore = mockCache.load([Product].self, forKey: "cached_products")
        #expect(cachedBefore?.first?.title == "Original Product")
        
        viewModel.updateProduct(updatedProduct)
        
        // The list holds the new values, and nothing got duplicated.
        #expect(viewModel.currentProducts.count == 1)
        #expect(viewModel.currentProducts.first?.title == "Updated Product")
        #expect(viewModel.currentProducts.first?.price == 12)
        
        let cachedAfter = mockCache.load([Product].self, forKey: "cached_products")
        #expect(cachedAfter?.first?.title == "Updated Product")
        #expect(cachedAfter?.first?.price == 12)
    }
    
    @Test func updateProduct_withUnknownID_changesNothing() {
        let mockNetwork = MockNetworkService()
        let mockCache = MockDataCacheService()
        let viewModel = ProductViewModel(networkService: mockNetwork, cacheService: mockCache)
        
        let existingProduct = Product(id: 1, title: "Existing Product", description: "", price: 2, thumbnail: "")
        let strangerProduct = Product(id: 999, title: "Not In The List", description: "", price: 5, thumbnail: "")
        
        mockNetwork.result = .success(ProductsResponse(products: [existingProduct]))
        viewModel.fetchProducts()
        
        // No product has id 999, so updateProduct hits its guard and does nothing: guard let index = pr.firstIndex(where: { $0.id == product.id }) else { return }
        viewModel.updateProduct(strangerProduct)
        
        #expect(viewModel.currentProducts.count == 1)
        #expect(viewModel.currentProducts.first?.title == "Existing Product")
        
        let cached = mockCache.load([Product].self, forKey: "cached_products")
        #expect(cached?.count == 1)
        #expect(cached?.first?.title == "Existing Product")
    }
    
}
