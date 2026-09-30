@testable import Training_Project

final class MockProfileViewModelDelegate: ProfileViewModelDelegate {

    func didTapLogoutButton() {
        print("Logging Out")
    }
}
