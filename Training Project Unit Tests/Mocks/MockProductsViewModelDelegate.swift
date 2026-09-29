@testable import Training_Project

final class MockProductsViewModelDelegate: ProductsViewModelDelegate {
    private(set) var didError: Error?
 
    func didErrorOccurr(error: Error) {
        didError = error
    }
}
