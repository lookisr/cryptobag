//
//  StockViewPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 26.05.2023.
//

import Foundation


protocol StockPresenterProtocol: AnyObject {
    
}

class StockViewPresenter: StockPresenterProtocol{
    weak var mainView: StockViewController?
    var router: MainRouterProtocol?
}
