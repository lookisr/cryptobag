//
//  HomeViewController.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var activityIndicator : UIActivityIndicatorView = {
      let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.style = .medium
        return indicator
    }()
    
    private var labal: UILabel = {
        let labal = UILabel()
        labal.text = "543"
        return labal
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.labal.text = "123/1233"
        self.setupUI()
        
        AuthService.shared.fetchUser { [weak self] user, error in
                   guard let self = self else { return }
                   if let error = error {
                       AlertManager.showFetchingUserError(on: self, with: error)
                       return
                   }
                   
                   if let user = user {
                       print("\(user.username)\n\(user.email)")
                       self.labal.text = "\(user.username)\(user.email)"
                   }
               }
        
    }
    
    private func setupUI(){
        activityIndicator.startAnimating()
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTabLogout))
        
        
        self.view.addSubview(activityIndicator)
        self.view.addSubview(labal)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        labal.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            labal.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 12),
            
        ])
    }
    
    
    @objc private func didTabLogout(){
        AuthService.shared.signOut { [weak self] error in
                   guard let self = self else { return }
                   if let error = error {
                       AlertManager.showLogoutError(on: self, with: error)
                       return
                   }
                   
                   if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                       sceneDelegate.checkAuthentication()
                   }
               }
    }
    

}
