//
//  LoginViewController.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//

import UIKit

protocol LoginViewProtocol: AnyObject {
    func showInvalidEmailAlert()
    func showInvalidPasswordAlert()
    func showSignInErrorAlert(with error: Error)
    func navigateToRegistrationScreen()
    func navigateToForgotPasswordScreen()
    func navigateToHomeScreen()
}

class LoginViewController: UIViewController, LoginViewProtocol {
    
    private let headerView = AuthView(title: "Сrypto.bag", subTitle: "sign in to your account")
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "New User? Create Account", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)
    init(presenter: LoginPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var presenter: LoginPresenterProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
                
        signInButton.addTarget(self, action: #selector(didTabSignIn), for: .touchUpInside)
        newUserButton.addTarget(self, action: #selector(didTabNewUser), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTabForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(signInButton)
        view.addSubview(newUserButton)
        view.addSubview(forgotPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 190),
            
            email.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            email.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            email.heightAnchor.constraint(equalToConstant: 55),
            email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            password.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            password.heightAnchor.constraint(equalToConstant: 55),
            password.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            signInButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 22),
            signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 55),
            signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            newUserButton.heightAnchor.constraint(equalToConstant: 44),
            newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 4),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            forgotPasswordButton.heightAnchor.constraint(equalToConstant: 33),
            forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
    }
    
    @objc private func didTabSignIn() {
        let loginRequest = LoginUserRequest(
            email: email.text ?? "",
            password: password.text ?? ""
        )
        
        presenter.signIn(with: loginRequest)
    }
    
    @objc private func didTabNewUser() {
        print(123)
        presenter.navigateToRegistrationScreen()
    }
    
    @objc private func didTabForgotPassword() {
        presenter.navigateToForgotPasswordScreen()
    }
    
    // MARK: - LoginViewProtocol
    
    func showInvalidEmailAlert() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidPasswordAlert() {
        AlertManager.showInvalidPasswordAlert(on: self)
    }
    
    func showSignInErrorAlert(with error: Error) {
        AlertManager.showSignInErrorAlert(on: self, with: error)
    }
    
    func navigateToRegistrationScreen() {
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToForgotPasswordScreen() {
        let vc = ForgotPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigateToHomeScreen() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
}

