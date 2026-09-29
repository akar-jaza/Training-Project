import Foundation
import RxSwift
@testable import Training_Project

final class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Any, Error> = .failure(NetworkError.noData)
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
    
    
    func requestDataAsync(url: URL, method: Training_Project.HTTPMethod) async throws -> Data {
        lastRequestedURL = url
        switch result {
        case .success(let value):
            return value as? Data ?? Data()
        case .failure(let error):
            throw error
        }
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
    
    /** TODO: Learn what each function does
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
     
     */


