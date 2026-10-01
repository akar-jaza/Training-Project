@testable import Training_Project

final class MockLoginViewModelDelegate: LoginViewModelDelegate {
    private(set) var didAuthenticateUser: User?
    private(set) var didFailWithError: Error?

    func didAuthenticateSuccessfully(user: User) {
        didAuthenticateUser = user
    }

    func didFailToAuthenticate(with error: Error) {
        didFailWithError = error
    }
}
