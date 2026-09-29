import Foundation
@testable import Training_Project


final class MockDataCacheService: DataCacheServiceProtocol {
 
    private var storage: [String: Any] = [:]
 
    func save<T: Encodable>(_ value: T, forKey key: String) {
        storage[key] = value
    }
 
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        storage[key] as? T
    }
 
    func saveData(_ data: Data, forkey key: String) {
        storage[key] = data
    }
 
    func loadData(forKey key: String) -> Data? {
        storage[key] as? Data
    }
}
