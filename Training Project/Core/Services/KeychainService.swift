import Foundation
import Security

final class KeychainService {
  // I just added these comments to make it easier to understand keychain service.
    static let shared = KeychainService()
    private init() {}
    
    private let service = "com.trainingproject.app" // a unique string that identifies our app
    
    func save(_ data: Data, forKey key: String) {
//         simplest way to handle update. delete whatever was there, then add fresh.
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // it means we are storing a password
            kSecAttrService as String: service, // belongs to which app
            kSecAttrAccount as String: key, // in simple terms it identifies the data
            kSecValueData as String: data, // the data we want to store 
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            // only readable while the phone is unlocked, and never included in iCloud/iTunes backups
        ]
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // in simple terms it tells keychain we are looking for a password
            kSecAttrService as String: service, 
            kSecAttrAccount as String: key, 
            kSecReturnData as String: true, // return the data
            kSecMatchLimit as String: kSecMatchLimitOne // only one match
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        // errSecSuccess means it worked. Keychain's version of a 200.
        guard status == errSecSuccess else { return nil }
        return result as? Data
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service, 
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary) // delete the item if found, CFDictionary tells keychain what we are looking for
    }
}
