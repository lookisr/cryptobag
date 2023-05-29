import UIKit

protocol RegisterView: AnyObject {
    func showInvalidUsernameAlert()
    func showInvalidEmailAlert()
    func showInvalidPasswordAlert()
    func showRegistrationErrorAlert(with error: Error?)
    func registrationSuccess()
}

class RegisterViewController: UIViewController, RegisterView {
    
    private let headerView = AuthView(title: "Сrypto.bag", subTitle: "Create your account")
    private let username = CustomTextField(fieldType: .username)
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .med)
    private let signInButton = CustomButton(title: "Already have an account? Sign In", fontSize: .med)
    
    private var presenter: RegisterPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RegisterPresenter(view: self)
        setupUI()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(username)
        view.addSubview(password)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(email)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),
            
            username.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            username.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            username.heightAnchor.constraint(equalToConstant: 55),
            username.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 22),
            email.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            email.heightAnchor.constraint(equalToConstant: 55),
            email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            password.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            password.heightAnchor.constraint(equalToConstant: 55),
            password.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signUpButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 22),
            signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 11),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    @objc func didTapSignUp() {
        let registerUserRequest = RegisterUserRequest(
            username: username.text ?? "",
            email: email.text ?? "",
            password: password.text ?? ""
        )
        
        presenter.registerUser(with: registerUserRequest)
    }
    
    @objc private func didTapSignIn() {
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    // MARK: - RegisterView methods
    
    func showInvalidUsernameAlert() {
        AlertManager.showInvalidUsernameAlert(on: self)
    }
    
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidPasswordAlert() {
        AlertManager.showInvalidPasswordAlert(on: self)
    }
    
    func showRegistrationErrorAlert(with error: Error?) {
        AlertManager.showRegistrationErrorAlert(on: self, with: error!)
    }
    
    func registrationSuccess() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
}

