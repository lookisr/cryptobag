//
//  HomeViewPresentor.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 29.05.2023.
//

import UIKit
class HomePresenter {
    private weak var view: HomeView?
    
    init(view: HomeView) {
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
