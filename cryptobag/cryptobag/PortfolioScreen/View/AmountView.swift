//
//  AmountView.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 01.06.2023.
//

import Foundation
import UIKit

class AmountViewController: UIViewController, UITextFieldDelegate{
    var ticker: Ticker
    var amount: Double?
    var presenter: ListPresenter?
    init(ticker: Ticker) {
        self.ticker = ticker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var inputField: UITextField = {
        let view = UITextField()
        view.placeholder = "Enter amount"
        view.font = UIFont(name: "MulishRoman-Regular", size: 14.0)
        view.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 25
        view.textAlignment = .center
        view.keyboardType = .decimalPad
        return view
    }()
    private lazy var addButton: UIButton = {
        let view = UIButton()
        view.layer.backgroundColor = UIColor(red: 0.369, green: 0.871, blue: 0.6, alpha: 1).cgColor
        view.layer.cornerRadius = 25
        view.titleLabel?.isEnabled = true
        view.setTitle("Add to portfolio", for: .normal)
        view.titleLabel?.textColor = .white
        return view
    }()
    private lazy var mainLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "MulishRoman-Bold", size: 18.0)
        view.text = "\(ticker.name)"
        return view
    }()
    
    override func viewDidLoad() {
        setupUI()
        setupConstraints()
        super.viewDidLoad()
        inputField.delegate = self
        disableButton()
        addButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    func setupUI() {
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        view.addSubview(addButton)
        view.addSubview(inputField)
        view.addSubview(mainLabel)
        
        
    }
    func setupConstraints(){
        mainLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(50)
            make.centerX.equalTo(view.center.x)
        }
        inputField.snp.makeConstraints{make in
            make.top.equalTo(mainLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view.center.x)
            make.width.equalTo(250)
            make.height.equalTo(150)
        }
        addButton.snp.makeConstraints{make in
            make.top.equalTo(inputField.snp.bottom).offset(20)
            make.centerX.equalTo(view.center.x)
            make.width.equalTo(345)
            make.height.equalTo(50)
        }
    }
    @objc func buttonTapped() {
        let amount = Double(inputField.text!)
        presenter!.addButtonTapped(ticker: self.ticker, amount: amount!)
        }
    func disableButton() {
        addButton.isEnabled = false
        addButton.layer.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1).cgColor
    }
    func enableButton(){
        addButton.isEnabled = true
        addButton.layer.backgroundColor = UIColor(red: 0.369, green: 0.871, blue: 0.6, alpha: 1).cgColor

    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text {
            if let intValue = Int(text) {
                // Если значение может быть преобразовано в Int,
                // считаем его допустимым
                enableButton()
            } else if let doubleValue = Double(text) {
                // Если значение может быть преобразовано в Double,
                // считаем его допустимым
                enableButton()
            } else {
                // Если значение не может быть преобразовано ни в Int, ни в Double,
                // считаем его недопустимым
                disableButton()
            }
        } else {
            // Если значение пустое, отключаем кнопку
            disableButton()
            
        }
    }}
