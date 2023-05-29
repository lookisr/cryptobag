//
//  CustomTextField.swift
//  cryptobag
//
//  Created by Роман Гиниятов on 03.04.2023.
//

import UIKit

class CustomTextField: UITextField {

    enum CustomTextField {
        case username
        case email
        case password
    }
    
    private let authFieldType: CustomTextField
    
    init(fieldType: CustomTextField) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        self.returnKeyType = .done
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.systemGreen.cgColor
        self.layer.masksToBounds = true
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType{
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }
    

    
    required init(coder: NSCoder) {
        fatalError("error")
    }

}

