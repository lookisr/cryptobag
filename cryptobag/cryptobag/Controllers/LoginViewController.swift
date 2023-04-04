//
//  LoginViewController.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let headerView = AuthView(title: "Сrypto.bag", subTitle: "sign in to you account")
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    private let signInButton = CustomButton(title: "Sign In", hasBackground: true, fontSize: .big)
    private let newUserButton = CustomButton(title: "New User? Create Account", fontSize: .med)
    private let forgotPasswordButton = CustomButton(title: "Forgot Password?", fontSize: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.signInButton.addTarget(self, action: #selector(didTabSignIn), for: .touchUpInside)
        self.newUserButton.addTarget(self, action: #selector(didTabNewUser), for: .touchUpInside)
        self.forgotPasswordButton.addTarget(self, action: #selector(didTabForgotPassword), for: .touchUpInside)
        
        
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden
    }
    
    
    private func setupUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(headerView)
        self.view.addSubview(email)
        self.view.addSubview(password)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        self.view.addSubview(forgotPasswordButton)
      
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
      
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 190),
            
            self.email.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.email.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            self.password.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.password.heightAnchor.constraint(equalToConstant: 55),
            self.password.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            self.signInButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            self.forgotPasswordButton.topAnchor.constraint(equalTo: newUserButton.bottomAnchor, constant: 4),
            self.forgotPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.forgotPasswordButton.heightAnchor.constraint(equalToConstant: 33),
            self.forgotPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
        
    }

    @objc private func didTabSignIn(){
        let loginRequest = LoginUserRequest(
                   email: self.email.text ?? "",
                   password: self.password.text ?? ""
               )
               

               if !Validator.isValidEmail(for: loginRequest.email) {
                   AlertManager.showInvalidEmailAlert(on: self)
                   return
               }
               
               if !Validator.isPasswordValid(for: loginRequest.password) {
                   AlertManager.showInvalidPasswordAlert(on: self)
                   return
               }
               
               AuthService.shared.signIn(with: loginRequest) { error in
                   if let error = error {
                       AlertManager.showSignInErrorAlert(on: self, with: error)
                       return
                   }
                   
                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                       sceneDelegate.checkAuthentication()
                   }
               }
    }
    @objc private func didTabNewUser(){
        let vc = RegisterViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func didTabForgotPassword(){
        let vc = ForgotPasswordViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
