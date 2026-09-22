import Foundation

protocol DataCacheServiceProtocol {
    func save<T: Encodable>(_ value: T, forKey key: String)
    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T?
    
    func saveData(_ data: Data, forkey key: String)
    func loadData(forKey key: String) -> Data?
}
final class DataCacheService: DataCacheServiceProtocol {

    static let shared = DataCacheService()
    private init() {}

    private var cacheDirectory: URL {
        //  /Users/akarjaza/Library/Caches/MyAppName/DataCache
        //  Caches Directory: System automatically cleans up
        // userDomainMask: gets the current user's cache folder URLs
        // [0]: returns the first URL in the array
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(forKey key: String) -> URL {
        cacheDirectory.appendingPathComponent("\(key).json")
    }

    func save<T: Encodable>(_ value: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: fileURL(forKey: key))
        } catch {
            print("Failed to cache \(key): \(error)")
        }
    }

    func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = try? Data(contentsOf: fileURL(forKey: key)) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func saveData(_ data: Data, forkey key: String) {
        do {
            try data.write(to: fileURL(forKey: key))
        } catch {
            print("Failed to cache \(key): \(error)")
        }
    }
    
    func loadData(forKey key: String) -> Data? {
        try? Data(contentsOf: fileURL(forKey: key))
    }
}
