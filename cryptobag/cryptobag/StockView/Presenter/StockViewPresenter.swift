//
//  StockViewPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 26.05.2023.
//

import Foundation


protocol StockPresenterProtocol: AnyObject {
    var mainView: StockViewController? {get set}
    var router: MainRouterProtocol? {get set}
    var chartData: Graph? {get set}
    func fetchChartData(with ticker: Ticker)
}

class StockViewPresenter: StockPresenterProtocol{
    var dataService: DataModel?
    weak var mainView: StockViewController?
    var router: MainRouterProtocol?
    var chartData: Graph?
    var ticker: Ticker?
    
    func fetchChartData(with ticker: Ticker) {
        dataService?.getGraphData(with: ticker.id) {result in
            switch result {
            case .success(let data):
                self.chartData = GraphData.generateFakeData(minPrice: data.first!.low, maxPrice: data.first!.high)
                self.mainView?.updateView()
            case .failure(let error):
                print(error)
            }
        }
    }
}
