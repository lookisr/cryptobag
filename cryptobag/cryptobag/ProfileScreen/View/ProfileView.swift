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
    private var logoutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        return button
    }()
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "door.left.hand.open")
        view.layer.backgroundColor = UIColor(named:"gray")?.cgColor
        view.tintColor = .systemGreen
        view.layer.cornerRadius = 10
        return view
    }()
    private var label: UILabel = {
        let label = UILabel()
        label.text = "543"
        return label
    }()
    private var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "MulishRoman-SemiBold", size: 16.0)
        label.textColor = UIColor(red: 0.082, green: 0.174, blue: 0.026, alpha: 1)
        return label
    }()
    private var logoutLabel: UILabel = {
        let label = UILabel()
        label.text = "Logout"
        label.font = UIFont(name: "MulishRoman-Bold", size: 16.0)
        label.textColor = UIColor(red: 0.082, green: 0.174, blue: 0.026, alpha: 1)
        return label
    }()
    private var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "123/1233"
        presenter = ProfilePresenter(view: self)
        setupUI()
        presenter.fetchUser()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.addSubview(label)
        
        logoutButton.addAction(UIAction(handler: {_ in self.presenter.logout()}), for: .touchDown)
        let stackView = UIButton()
        view.addSubview(settingsLabel)
        stackView.addSubview(logoutButton)
        stackView.addSubview(imageView)
        view.addSubview(stackView)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y)
        }
        label.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.centerX.equalTo(view.center.x)
            make.bottom.equalTo(activityIndicator.snp.top).offset(10)
            make.height.equalTo(30)
        }
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(label.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(10)
        }
        settingsLabel.snp.makeConstraints{ make in
            make.top.equalTo(label.snp.bottom).offset(10)
            make.left.equalTo(view.snp.left).offset(16)
            make.height.equalTo(20)
        }
        logoutButton.snp.makeConstraints{ make in
            make.top.equalTo(settingsLabel.snp.bottom).offset(12)
            make.left.equalTo(stackView.snp.left)
            make.right.equalTo(stackView.snp.right)
            make.height.equalTo(68)
            make.width.equalTo(358)
        }
        imageView.snp.makeConstraints{make in
            make.top.equalTo(stackView.snp.top).offset(32)
            make.left.equalTo(stackView.snp.left).offset(16)
            make.height.equalTo(44)
            make.width.equalTo(44)
            
        }
        logoutButton.addSubview(logoutLabel)
        logoutLabel.snp.makeConstraints{ make in
            make.top.equalTo(logoutButton.snp.top).offset(24)
            make.left.equalTo(imageView.snp.right).offset(10)
        }
    }
    
    @objc private func didTapLogout() {
        presenter.logout()
    }
    
    // MARK: - HomeView methods
    
    func showUserData(username: String, email: String) {
        label.text = "\(username)\n\(email)"
        label.font = UIFont(name: "MulishRoman-Bold", size: 24.0)
        label.textColor = UIColor(red: 0.082, green: 0.174, blue: 0.026, alpha: 1)
        activityIndicator.stopAnimating()
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


