//
//  MainPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 12.04.2023.
//

import Foundation
import UIKit

//protocol MainViewProtocol: AnyObject {
//    func updateView()
//    func updateCell(for indexPath: IndexPath)
//    func updateView(withLoader isLoading: Bool)
//}

protocol MainPresenterProtocol {
    var tickers: [Ticker] {get}
    var mainView: MainViewController? {get set}
    func loadView()
    func search(for query: String)
    func cancelSearch()
    func model(for indexPath: Int) -> Ticker
    func getImageForCoin(id: String, indexPath: IndexPath)
    func openCell(with ticker: Ticker)
}


class MainPresenter: MainPresenterProtocol {
    var originalTickers: [Ticker]?
    func search(for query: String) {
        let filteredTickers = tickers.filter { $0.name.lowercased().contains(query.lowercased()) }
        self.tickers = filteredTickers
        mainView?.updateView()
    }
    
    func cancelSearch() {
        self.tickers = originalTickers!
        mainView?.updateView()
    }
    
    
    private let dataService: DataModel
    var router: MainRouterProtocol?
    var tickers: [Ticker] = []
    weak var mainView: MainViewController?
    
    init(dataService: DataModel) {
        self.dataService = dataService
    }
    
    func loadView() {
        dataService.fetchDataTickers {result in
            self.mainView?.updateView()
            self.tickers = result
            self.originalTickers = result
            print("trying to load view")
            self.mainView?.updateView()
        }
    }
    
    func openCell(with ticker: Ticker) {
        router?.moveToDetailedScreen(with: ticker)
    }
    
    func model(for indexPath: Int) -> Ticker {
        tickers[indexPath]
    }
    
    func getImageForCoin(id: String, indexPath: IndexPath) {
        if let cachedImageURL = ImageHelper.shared.getCachedImageURL(for: id) {
            // Если кешированное изображение найдено, используем его
            self.tickers[indexPath.row].logo = cachedImageURL
        } else {
            dataService.getImageURL(with: id) { result in
                        switch result {
                        case .success(let image):
                            self.tickers[indexPath.row].logo = image.logo
                            // Кеширование ссылки на изображение
                            ImageHelper.shared.cacheImageURL(for: id, link: image.logo)
                        case .failure(let error):
                            // Обработка ошибки
                            print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                            // Установка плейсхолдер-изображения
                            self.tickers[indexPath.row].logo = "https://www.svgrepo.com/show/135240/bitcoin-placeholder.svg"
                        }
                    }
        }
    }

}

