//
//  PortfolioPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 30.05.2023.
//

import Foundation
import UIKit

protocol PortfolioPresenterProtocol: AnyObject{
    var portfolioView: PortfolioView? {get set}
}

class PortfolioPresenter: PortfolioPresenterProtocol {
    weak var portfolioView: PortfolioView?
}
