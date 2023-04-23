//
//  ForgotPasswordViewController.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    private let headView = AuthView(title: "Forgot Password", subTitle: "Reset your password")
    
    private let email = CustomTextField(fieldType: .email)
    
    private let resetPasswordButton = CustomButton(title: "Sign Up",hasBackground: true, fontSize: .big)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    private func setupUI(){
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headView)
        self.view.addSubview(email)
        self.view.addSubview(resetPasswordButton)
        
        headView.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            self.headView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30 ),
            self.headView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headView.heightAnchor.constraint(equalToConstant: 230),
            
            self.email.topAnchor.constraint(equalTo: headView.bottomAnchor, constant: 11),
            self.email.centerXAnchor.constraint(equalTo: headView.centerXAnchor),
            self.email.heightAnchor.constraint(equalToConstant: 55),
            self.email.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.resetPasswordButton.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 22),
            self.resetPasswordButton.centerXAnchor.constraint(equalTo: headView.centerXAnchor),
            self.resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            self.resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            
        ])
    }
    
   @objc private  func didTapForgotPassword(){
       let email = self.email.text ?? ""
              
              if !Validator.isValidEmail(for: email) {
                  AlertManager.showInvalidEmailAlert(on: self)
                  return
              }
              
              AuthService.shared.forgotPassword(with: email) { [weak self] error in
                  guard let self = self else { return }
                  if let error = error {
                      AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                      return
                  }
                  
                  AlertManager.showPasswordResetSent(on: self)
              }
          }
}
