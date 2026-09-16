import Foundation

protocol UserSessionServiceProtocol {
    var isLoggedIn: Bool { get }
    func save(_ user: User)
    func getCurrentUser() -> User?
    func clear()
}

final class UserSessionService: UserSessionServiceProtocol {
    static let shared = UserSessionService()
    private init() {}
    
    private let keychain = KeychainService.shared
    private let userKey = "currentUser"
    
    var isLoggedIn: Bool {
        getCurrentUser() != nil // returns true if user exists
    }

    func save(_ user: User) {
        do {
            let data = try JSONEncoder().encode(user) // converts user object into data
            keychain.save(data, forKey: userKey) // saves data in keychain
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func getCurrentUser() -> User? {
        guard let data = keychain.get(forKey: userKey) else { // get data from keychain
            return nil // if there was no data, we return nil
        }
        return try? JSONDecoder().decode(User.self, from: data) // converts data into user object
    }
    
    func clear() {
        keychain.delete(forKey: userKey) // deletes data from keychain
    }

    
}
