import Foundation
@testable import Training_Project

final class MockKeychainService: KeychainServiceProtocol {
    private var keychain: [String: Any] = [:]

    func save(_ data: Data, forKey key: String) {
        keychain[key] = data
    }

    func get(forKey key: String) -> Data? {
        keychain[key] as? Data
    }

    func delete(forKey key: String) {
        keychain.removeValue(forKey: key)
    }
}
