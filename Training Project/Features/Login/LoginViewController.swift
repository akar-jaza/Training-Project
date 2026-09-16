import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let loginView = LoginView()
    let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    private let isLoading = BehaviorSubject<Bool>(value: false)
    
    
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
            
            loginView.usernameTextField.text = "emilys"
            loginView.passwordTextField.text = "emilyspass"
        }).disposed(by: disposeBag)
    }
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func didAuthenticateSuccessfully(user: User) {
        isLoading.onNext(false)
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate else { return }
        UserSessionService.shared.save(user)
        sceneDelegate.switchToMain()
    }
    
    func didFailToAuthenticate(with error: any Error) {
        isLoading.onNext(false)
        showAlert(title: "Login Failed", message: "Incorrect username or password. Try 'emilys' and 'emilyspass'.")
    }
}
