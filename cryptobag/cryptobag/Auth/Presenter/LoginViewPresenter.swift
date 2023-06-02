//
//  LoginViewPresenter.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 29.05.2023.
//

import UIKit

protocol LoginPresenterProtocol {
    func signIn(with request: LoginUserRequest)
    func navigateToRegistrationScreen()
    func navigateToForgotPasswordScreen()
}

class LoginPresenter: LoginPresenterProtocol {
    
    weak var view: LoginViewProtocol?
    
    
    func signIn(with request: LoginUserRequest) {
        if !Validator.isValidEmail(for: request.email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        if !Validator.isPasswordValid(for: request.password) {
            view?.showInvalidPasswordAlert()
            return
        }
        
        AuthService.shared.signIn(with: request) { [weak self] error in
            if let error = error {
                self?.view?.showSignInErrorAlert(with: error)
                return
            }
            
            self?.view?.navigateToHomeScreen()
        }
    }
    
    func navigateToRegistrationScreen() {
        view?.navigateToRegistrationScreen()
    }
    
    func navigateToForgotPasswordScreen() {
        view?.navigateToForgotPasswordScreen()
    }
}
