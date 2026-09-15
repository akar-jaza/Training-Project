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
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL, method: HTTPMethod, body: [String: Any]?) -> Observable<T>
    
    func requestData(url: URL, method: HTTPMethod) -> Observable<Data>
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    
    func request<T: Decodable>(
        url: URL,
        method: HTTPMethod,
        body: [String : Any]? = nil
    ) -> RxSwift.Observable<T> {
        requestData(url: url, method: method, body: body) .map { data in
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }

        }
    }
    
    func requestData(url: URL, method: HTTPMethod = .get) -> Observable<Data> {
        requestData(url: url, method: method, body: nil)
    }

    private func requestData(
        url: URL,
        method: HTTPMethod,
        body: [String: Any]?
    ) -> Observable<Data> {
        Observable.create { observer in
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            if let body = body {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body)
                } catch {
                    observer.onError(NetworkError.requestFailed(error))
                    return Disposables.create()
                }
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    observer.onError(NetworkError.requestFailed(error))
                    return
                }
                
                guard let data = data else {
                    observer.onError(NetworkError.noData)
                    return
                }
                
                observer.onNext(data)
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .observe(on: MainScheduler.instance)
    }

    
}
