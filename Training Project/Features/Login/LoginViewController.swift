import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    let loginView = LoginView()
    let viewModel = LoginViewModel()
    weak var coordinator: LoginCoordinator?
    private let disposeBag = DisposeBag()
    private let isLoading = BehaviorSubject<Bool>(value: false)
    
    // password is always "{username}pass"
    private let demoUsernames = [
        "emilys", "michaelw", "sophiab", "jamesd", "emmaj", "oliviaw", "alexanderj",
        "avat", "ethanm", "isabellad", "liamg", "miar", "noahh", "charlottem", "williamg",
        "averyp", "evelyns", "logant", "abigailr", "jacksone", "madisonc", "elijahs",
        "chloem", "mateon", "harpere", "evelyng", "danielc", "lilyb", "henryh", "addisonw"
    ]
    
    override func loadView() {
        view = loginView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setupLoginButtonBinding()
        fillTheLoginFields()
    }
    
}
// MARK: - Action Buttons

extension LoginViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Bindings

extension LoginViewController {
    private func setupLoginButtonBinding() {
        
        isLoading
            .bind(to: loginView.loginButton.rx.isLoading)
            .disposed(by: disposeBag)
        
        
        loginView.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let username = loginView.usernameTextField.text ?? ""
                let password = loginView.passwordTextField.text ?? ""
                
                guard !username.isEmpty, !password.isEmpty else {
                    return showAlert(title: "Missing Fields", message: "Please enter username and password.")
                }
                
                isLoading.onNext(true)
                
                viewModel.authenticateUser(username: username, password: password)
                
            }).disposed(by: disposeBag)
        
    }
    
    private func fillTheLoginFields() {
        loginView.hintButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let username = demoUsernames.randomElement()!

            loginView.usernameTextField.text = username
            loginView.passwordTextField.text = "\(username)pass"
        }).disposed(by: disposeBag)
    }
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func didAuthenticateSuccessfully(user: User) {
        isLoading.onNext(false)
        UserSessionService.shared.save(user)
        coordinator?.finishLogin()
    }
    
    func didFailToAuthenticate(with error: any Error) {
        isLoading.onNext(false)
        print("error in sign in: \(error)")
        showAlert(title: "Login Failed", message: "Incorrect username or password. Try 'emilys' and 'emilyspass'.")
    }
}
