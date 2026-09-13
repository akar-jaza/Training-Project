import UIKit

final class LoginView: UIView, ViewCode {
    
    let welcomeImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "welcome"))
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(named: "loginBgColor")
        textField.layer.cornerRadius = 12
        // add a border
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.autocapitalizationType = .none
        
        // left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(named: "loginBgColor")
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 12
        textField.isSecureTextEntry = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    let loginButton: LoadingButton = {
        let button = LoadingButton(frame: .zero)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let hintButton: UIButton = {
        let button = UIButton(type: .system)
        
        let fullText = "psst... use username: emilys and password: emilyspass or touch me to fill the fields"
        let clickableText = "touch me"
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.systemFont(ofSize: 14)
        ]
        
        let attributedString = NSMutableAttributedString(string: fullText, attributes: defaultAttributes)
        
        let range = (fullText as NSString).range(of: clickableText)
        
        let clickableAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.italicSystemFont(ofSize: 14)
        ]
        
        attributedString.addAttributes(clickableAttributes, range: range)
        
        button.setAttributedTitle(attributedString, for: .normal)
        
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "loginBgColor")
        buildViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        addSubview(welcomeImage)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        addSubview(hintButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                // image
                welcomeImage.centerXAnchor
                    .constraint(equalTo: centerXAnchor),
                welcomeImage.topAnchor
                    .constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                welcomeImage.leadingAnchor.constraint(equalTo: leadingAnchor),
                welcomeImage.trailingAnchor.constraint(equalTo: trailingAnchor),
                welcomeImage.heightAnchor.constraint(equalToConstant: 250),
                
                // Username
                usernameTextField.centerXAnchor
                    .constraint(equalTo: centerXAnchor),
                usernameTextField.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                usernameTextField.heightAnchor.constraint(equalToConstant: 50),
                
                // password
                passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
                passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                passwordTextField.heightAnchor.constraint(equalToConstant: 50),
                
                // hint button
                hintButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
                hintButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                hintButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                
                // button
                loginButton.bottomAnchor
                    .constraint(
                        equalTo: bottomAnchor,
                        constant: -32
                    ),
                loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
                loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
                loginButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
    }
    
    
}
