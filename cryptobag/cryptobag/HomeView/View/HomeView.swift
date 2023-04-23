//
//  HomeView.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 09.04.2023.
//
import Foundation
import UIKit
import SnapKit

class MainViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table =  UITableView()
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        DataModel.shared.fetchDataTickers()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(red: 242, green: 242, blue: 242, alpha: 100)
        var searcher = UISearchBar()
        view.addSubview(searcher)
        searcher.autocapitalizationType = .none
        searcher.searchBarStyle = .minimal
        searcher.placeholder = "Search"
        searcher.searchTextField.layer.cornerRadius = 8
        searcher.snp.makeConstraints{(make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
}


