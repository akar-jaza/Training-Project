import Foundation
import RxSwift
@testable import Training_Project

final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Any, Error> = .failure(NetworkError.noData)
    var imageResult: Result<Data, Error> = .failure(NetworkError.noData)
    private(set) var lastRequestedURL: URL?
    
    func requestAsync<T>(url: URL, method: Training_Project.HTTPMethod, body: [String : Any]?) async throws -> T where T : Decodable {
        lastRequestedURL = url
        
        switch result {
        case .success(let value):
            guard let typed = value as? T else {
                throw NetworkError.decodingFailed(NSError(domain: "MockNetworkService", code: 0))
            }
            return typed
            
        case .failure(let error):
            throw error
        }
    }
    
    func requestDataAsync(
        url: URL,
        method: Training_Project.HTTPMethod
    ) async throws -> Data {
        lastRequestedURL = url
        return try imageResult.get()
    }
    
    func request<T>(url: URL, method: Training_Project.HTTPMethod, body: [String : Any]?) -> RxSwift.Observable<T> where T : Decodable {
        lastRequestedURL = url
        switch result {
        case .success(let value):
            guard let typed = value as? T else {
                return Observable.error(NetworkError.decodingFailed(
                    NSError(domain: "MockNetworkService", code: 0)
                ))
            }
            return Observable.just(typed)
        case .failure(let error):
            return Observable.error(error)
        }
    }
    
    func requestData(url: URL, method: Training_Project.HTTPMethod) -> RxSwift.Observable<Data> {
        lastRequestedURL = url
        switch result {
        case .success(let value):
            return Observable.just(value as? Data ?? Data())
        case .failure(let error):
            return Observable.error(error)
        }
    }
}
    

