//
//  ProfilePresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 30.05.2023.
//

import Foundation
import UIKit
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewController? {get set}
    func fetchUser()
    func logout()
    
}

class ProfilePresenter {
    private weak var view: ProfileViewController?
    
    init(view: ProfileViewController) {
        self.view = view
    }
    
    func fetchUser() {
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
                self.view?.showFetchingUserError(with: error)
                return
            }
            
            if let user = user {
                self.view?.showUserData(username: user.username, email: user.email)
            }
        }
    }
    
    func logout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.view?.showLogoutError(with: error)
                return
            }
            
            self.view?.navigateToAuthentication()
        }
    }
}
