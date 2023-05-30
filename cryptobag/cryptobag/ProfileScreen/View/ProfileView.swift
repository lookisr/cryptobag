//
//  ProfileView.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 30.05.2023.
//

import Foundation

import UIKit
protocol ProfileViewProtocol: AnyObject {
    func showUserData(username: String, email: String)
    func showFetchingUserError(with error: Error)
    func showLogoutError(with error: Error)
    func navigateToAuthentication()
}

class ProfileViewController: UIViewController, ProfileViewProtocol {
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.style = .medium
        return indicator
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "543"
        return label
    }()
    
    private var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        label.text = "123/1233"
        
        presenter = ProfilePresenter(view: self)
        setupUI()
        presenter.fetchUser()
    }
    
    private func setupUI() {
        activityIndicator.startAnimating()
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        view.addSubview(label)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
        ])
    }
    
    @objc private func didTapLogout() {
        presenter.logout()
    }
    
    // MARK: - HomeView methods
    
    func showUserData(username: String, email: String) {
        label.text = "\(username)\n\(email)"
    }
    
    func showFetchingUserError(with error: Error) {
        AlertManager.showFetchingUserError(on: self, with: error)
    }
    
    func showLogoutError(with error: Error) {
        AlertManager.showLogoutError(on: self, with: error)
    }
    
    func navigateToAuthentication() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
}


