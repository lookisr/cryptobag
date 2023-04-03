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
        indicator.style = .large
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
        
    }
    

}
