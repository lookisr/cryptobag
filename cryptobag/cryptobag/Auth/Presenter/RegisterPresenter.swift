//
//  RegisterPresenter.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 29.05.2023.
//

import Foundation
class RegisterPresenter {
    private weak var view: RegisterView?
    init(view: RegisterView) {
        self.view = view
    }
    
    func registerUser(with request: RegisterUserRequest) {
        if !Validator.isValidUsername(for: request.username) {
            view?.showInvalidUsernameAlert()
            return
        }
        
        if !Validator.isValidEmail(for: request.email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        if !Validator.isPasswordValid(for: request.password) {
            view?.showInvalidPasswordAlert()
            return
        }
        
        AuthService.shared.registerUser(with: request) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showRegistrationErrorAlert(with: error)
                return
            }
            
            if wasRegistered {
                self.view?.registrationSuccess()
            } else {
                self.view?.showRegistrationErrorAlert(with: nil)
            }
        }
    }
}
