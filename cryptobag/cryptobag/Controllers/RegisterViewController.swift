//
//  RegisterViewController.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//
import UIKit

class RegisterViewController: UIViewController {
    
    private let headerView = AuthView(title: "Сrypto.bag", subTitle: "Create your account")
    private let username = CustomTextField(fieldType: .username)
    private let email = CustomTextField(fieldType: .email)
    private let password = CustomTextField(fieldType: .password)
    
    private let signUpButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .med)
    private let signInButton = CustomButton(title: "Already have account? Sign In", fontSize: .med)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.signInButton.addTarget(self, action: #selector(didTabSignIn), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden
    }
    
    
    private func setupUI(){
        self.view.backgroundColor = .white
        self.view.addSubview(headerView)
        self.view.addSubview(username)
        self.view.addSubview(password)
        self.view.addSubview(signInButton)
        self.view.addSubview(signUpButton)
        self.view.addSubview(email)
        
      
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        username.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
      
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 190),
            
            self.username.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.username.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.username.heightAnchor.constraint(equalToConstant: 55),
            self.username.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 22),
            self.email.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            self.password.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.password.heightAnchor.constraint(equalToConstant: 55),
            self.password.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signUpButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 22),
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
            
            
            self.signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 11),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 44),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
        ])
        
    }
    
    @objc func didTapSignUp(){
        let registerUserRequest = RegisterUserRequest(
                   username: self.username.text ?? "",
                   email: self.email.text ?? "",
                   password: self.password.text ?? ""
               )

               if !Validator.isValidUsername(for: registerUserRequest.username) {
                   AlertManager.showInvalidUsernameAlert(on: self)
                   return
               }

             if !Validator.isValidEmail(for: registerUserRequest.email) {
                 AlertManager.showInvalidEmailAlert(on: self)
                 return
             }
             

             if !Validator.isPasswordValid(for: registerUserRequest.password) {
                 AlertManager.showInvalidPasswordAlert(on: self)
                 return
             }
             
             AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
                 guard let self = self else { return }
                 
                 if let error = error {
                     AlertManager.showRegistrationErrorAlert(on: self, with: error)
                     return
                 }
                 
                 if wasRegistered {
                     if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                         sceneDelegate.checkAuthentication()
                     }
                 } else {
                     AlertManager.showRegistrationErrorAlert(on: self)
                 }
             }
    }

    @objc private func didTabSignIn(){
        let vc = HomeViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
