//
//  portfolioVoew.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 30.05.2023.
//

import Foundation
import UIKit
protocol PortfolioViewProtocol {
    var presenter: PortfolioPresenterProtocol? {get set}
}

class PortfolioView: UIViewController, PortfolioViewProtocol{
    var presenter: PortfolioPresenterProtocol?
}
