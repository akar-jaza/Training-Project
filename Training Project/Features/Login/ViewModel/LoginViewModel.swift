import Foundation
import RxSwift

protocol LoginViewModelDelegate: AnyObject {
    func didAuthenticateSuccessfully(user: User)
    func didFailToAuthenticate(with error: Error)
}

final class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    var networkService: NetworkServiceProtocol = NetworkService.shared
    var disposeBag = DisposeBag()
    
    func authenticateUser(username: String, password: String) {
        guard let url = URL(string: "https://dummyjson.com/auth/login") else {
            delegate?.didFailToAuthenticate(with: NetworkError.invalidURL)
            return
        }
        
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        networkService
            .request(url: url, method: .post, body: body)
            .subscribe(onNext: { (user: User) in
                self.delegate?.didAuthenticateSuccessfully(user: user)
            }, onError: { [weak self] error in
                self?.delegate?.didFailToAuthenticate(with: error)
            })
            .disposed(by: disposeBag)
    }
}

