//
//  Router.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 25.05.2023.
//

import Foundation
import UIKit

protocol MainRouterProtocol: AnyObject {
    var homeView: MainViewController? {get set}
    var stockView: StockViewController? {get set}
    func moveToDetailedScreen(with ticker: Ticker)
    func moveToPortfolio()
    func moveToProfileSettings()
}

class MainRouter: MainRouterProtocol {

    
    weak var stockView: StockViewController?
    weak var homeView: MainViewController?
    weak var authView: RegisterViewController?
    func moveToPortfolio() {
        
    }
    func moveToProfileSettings() {
        
    }
    
    
    func moveToDetailedScreen(with ticker: Ticker) {
        let stockScreen = MainModuleAssembly.configureStockScreen(ticker: ticker)
        homeView?.navigationController?.pushViewController(stockScreen, animated: true)
        homeView?.navigationController?.navigationBar.isHidden = false
    }




}

