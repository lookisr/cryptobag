//
//  AuthView.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//


import UIKit

class AuthView: UIView {
    
    

    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30,weight: .bold)
        label.text = "Error"
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20,weight: .regular)
        label.text = "Error"
        return label
    }()
    
    
    init(title: String, subTitle:String){
        super.init(frame: .zero)
        self.title.text = title
        self.subTitle.text = subTitle
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init error")
    }
    
    
    private func setupUI(){
        self.addSubview(title)
        self.addSubview(subTitle)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.title.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor,constant: 50),
            self.title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.subTitle.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 12),
            self.subTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.subTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }

}
