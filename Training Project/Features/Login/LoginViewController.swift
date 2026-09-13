import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    let loginView = LoginView()
    let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        loginView.loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                let username = loginView.usernameTextField.text ?? ""
                let password = loginView.passwordTextField.text ?? ""
                
                guard !username.isEmpty, !password.isEmpty else { return }
                
                viewModel
                    .authenticateUser(username: username, password: password) { success in
                        if success {
                            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                  let sceneDelegate = scene.delegate as? SceneDelegate else { return }
                            sceneDelegate.switchToMain()
                        }
                    }
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
