import Foundation
@testable import Training_Project

final class MockUserSessionService: UserSessionServiceProtocol {
    private let keychain: KeychainServiceProtocol
    private let userKey = "currentUser"

    init(keychain: KeychainServiceProtocol = MockKeychainService()) {
        self.keychain = keychain
    }

    var isLoggedIn: Bool {
        getCurrentUser() != nil
    }

    func save(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else { return }
        keychain.save(data, forKey: userKey)
    }

    func getCurrentUser() -> User? {
        guard let data = keychain.get(forKey: userKey) else { return nil }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func clear() {
        keychain.delete(forKey: userKey)
    }
}
