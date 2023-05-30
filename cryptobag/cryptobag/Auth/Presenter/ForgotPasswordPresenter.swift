//
//  ForgotPasswordPresenter.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 29.05.2023.
//

import Foundation
class ForgotPasswordPresenter {
    private weak var view: ForgotPasswordView?
    
    init(view: ForgotPasswordView) {
        self.view = view
    }
    
    func resetPassword(with email: String) {
        if !Validator.isValidEmail(for: email) {
            view?.showInvalidEmailAlert()
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.view?.showErrorSendingPasswordReset(with: error)
            } else {
                self.view?.showPasswordResetSent()
            }
        }
    }
}
