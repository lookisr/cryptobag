//
//  StockViewController.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 25.05.2023.
//

import Foundation
import UIKit

class StockViewController: UIViewController {
    private let ticker: Ticker
    var presenter: StockPresenterProtocol
    
    init(ticker: Ticker, presenter: StockPresenterProtocol) {
        self.ticker = ticker
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = ticker.name
        
        // Добавьте код для отображения детальной информации о ячейке
        let nameLabel = UILabel()
        nameLabel.text = ticker.name
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        // Размещение метки в представлении
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
