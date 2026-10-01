import Foundation
import RxSwift

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case requestFailed(Error)
    case serverError(Int, Data)
}

// MARK: - Protocol

protocol NetworkServiceProtocol {
    // RxSwift
    func request<T: Decodable>(url: URL, method: HTTPMethod, body: [String: Any]?) -> Observable<T>
    func requestData(url: URL, method: HTTPMethod) -> Observable<Data>
    
    // async/await
    func requestAsync<T: Decodable>(url: URL, method: HTTPMethod, body: [String: Any]?) async throws -> T
    func requestDataAsync(url: URL, method: HTTPMethod) async throws -> Data
}

// default values live here, works for the real service and for mocks
extension NetworkServiceProtocol {
    func request<T: Decodable>(url: URL, method: HTTPMethod) -> Observable<T> {
        request(url: url, method: method, body: nil)
    }
    
    func requestData(url: URL) -> Observable<Data> {
        requestData(url: url, method: .get)
    }
    
    func requestAsync<T: Decodable>(url: URL, method: HTTPMethod) async throws -> T {
        try await requestAsync(url: url, method: method, body: nil)
    }
    
    func requestDataAsync(url: URL) async throws -> Data {
        try await requestDataAsync(url: url, method: .get)
    }
}

// MARK: - Implementation

final class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    
    // MARK: async/await
    
    func requestAsync<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        body: [String: Any]?
    ) async throws -> T {
        let data = try await send(makeRequest(url: url, method: method, body: body))
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
    
    func requestDataAsync(url: URL, method: HTTPMethod) async throws -> Data {
        try await send(makeRequest(url: url, method: method, body: nil))
    }
    
    // MARK: RxSwift
    
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        body: [String: Any]?
    ) -> Observable<T> {
        makeObservable {
            try await self.requestAsync(url: url, method: method, body: body)
        }
    }
    
    func requestData(url: URL, method: HTTPMethod) -> Observable<Data> {
        makeObservable { try await self.requestDataAsync(url: url, method: method) }
    }

    private func makeObservable<T>(_ work: @escaping () async throws -> T) -> Observable<T> {
        Observable.create { observer in
            let task = Task {
                do {
                    let value = try await work()
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create { task.cancel() }
        }
        .observe(on: MainScheduler.instance)
    }
    
    // MARK: Shared helpers
    
    private func makeRequest(url: URL, method: HTTPMethod, body: [String: Any]?) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw NetworkError.requestFailed(error)
            }
        }
        return request
    }
    
    // Performs the request and returns the body only for 2(xx) responses
    private func send(_ request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw NetworkError.requestFailed(error)
        }
        
        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.serverError(http.statusCode, data)
        }
        return data
    }
}
