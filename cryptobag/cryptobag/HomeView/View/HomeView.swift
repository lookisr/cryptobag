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
    var presenter: MainPresenterProtocol
    lazy var tableView: UITableView = {
        let table =  UITableView(frame: .zero, style: .plain)
        table.rowHeight = 88.0

        table.register(CustomCell.self, forCellReuseIdentifier: String(describing: CustomCell.self))
        return table
    }()
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViewView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView()
    }
    
    func setupUI() {
        let backColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        tableView.backgroundColor = backColor
        tableView.rowHeight = 88.0
        let searcher = UISearchBar()
        view.addSubview(searcher)
        view.addSubview(tableView)
        searcher.autocapitalizationType = .none
        searcher.searchBarStyle = .minimal
        searcher.placeholder = "Search"
        searcher.searchTextField.layer.cornerRadius = 8
        searcher.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints{make in
            make.top.equalTo(searcher.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    private func setUpTableViewView() {
        view.backgroundColor = .white
        tableView.dataSource = self
    }
    
    func updateView() {
        print("view updated")
        tableView.reloadData()
    }
    
    func updateCell(for indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    func test(){
        print(123)
    }
    
}
    
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tickers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.configure(with: presenter.model(for: indexPath.row))
        return cell
    }
}
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
        
}

//extension MainViewController: MainViewProtocol {
//    func updateView() {
//        print("view updated")
//        tableView.reloadData()
//    }
//
//    func updateCell(for indexPath: IndexPath) {
//        tableView.reloadRows(at: [indexPath], with: .none)
//    }
//


