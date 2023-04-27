//
//  MainPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 12.04.2023.
//

import Foundation

//protocol MainViewProtocol: AnyObject {
//    func updateView()
//    func updateCell(for indexPath: IndexPath)
//    func updateView(withLoader isLoading: Bool)
//}

protocol MainPresenterProtocol {
    var tickers: [Ticker] {get}
    var mainView: MainViewController? {get set}
    func loadView()
    func model(for indexPath: Int) -> Ticker
}


class MainPresenter: MainPresenterProtocol {
    private let dataService: DataModel
    var tickers: [Ticker] = []
    weak var mainView: MainViewController?

    init(dataService: DataModel) {
        self.dataService = dataService
    }

    func loadView() {
        dataService.fetchDataTickers {result in
            self.mainView?.updateView()
            self.tickers = result
            print("trying to load view")
            self.mainView?.updateView()
        }
    }

    func model(for indexPath: Int) -> Ticker {
        tickers[indexPath]
    }
    
}

