import Foundation
import RxSwift

class LoginViewModel {
    var networkService: NetworkServiceProtocol = NetworkService.shared
    var disposeBag = DisposeBag()
    
    func authenticateUser(username: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/auth/login") else {
            completion(false)
            return
        }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        networkService
            .request(url: url, method: .post, body: body)
            .subscribe(onNext: { (_: User) in
//                print("success \(user)")
                completion(true)
            }, onError: {error in
                print(error)
                completion(false)
            })
            .disposed(by: disposeBag)
        
    }
}

