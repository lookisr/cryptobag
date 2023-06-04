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
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width, height: 88.0)
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return layout
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.style = .medium
        return indicator
    }()
    
    lazy var collectionView: UICollectionView = {
        let table =  UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        table.register(CustomCell.self, forCellWithReuseIdentifier: String(describing: CustomCell.self))
        return table
    }()
    
    lazy var searcher: UISearchBar = {
        let searcher = UISearchBar()
        searcher.autocapitalizationType = .none
        searcher.searchBarStyle = .minimal
        searcher.placeholder = "Search"
        searcher.searchTextField.layer.cornerRadius = 8
        
        return searcher
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
        searcher.delegate = self
        setupUI()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadView()
    }
    
    func setupUI() {
        let backColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        view.backgroundColor = backColor
        collectionView.backgroundColor = backColor
        view.addSubview(searcher)
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        searcher.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-8)
            make.bottom.equalTo(collectionView.snp.top)
        }
        collectionView.snp.makeConstraints{make in
            make.top.equalTo(searcher.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        activityIndicator.snp.makeConstraints{make in
            make.centerX.equalTo(view.center.x)
            make.centerY.equalTo(view.center.y)
        }
       
        
        
    }
    private func setUpTableViewView() {
        view.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateView() {
        print("view updated")
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func updateCell(for indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    func test(){
        print(123)
    }
    
}
    
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.tickers.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CustomCell.self), for: indexPath) as? CustomCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 10
        presenter.getImageForCoin(id: presenter.tickers[indexPath.row].id, indexPath: indexPath)
        cell.image.setImage(from: presenter.tickers[indexPath.row].logo, placeholder: UIImage(named: "error"))
        cell.configure(with: presenter.model(for: indexPath.row))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTicker = presenter.tickers[indexPath.row]
        presenter.openCell(with: selectedTicker)
    }

}
extension MainViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UICollectionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
        
}

extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        presenter.search(for: searchText)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.cancelSearch()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}


