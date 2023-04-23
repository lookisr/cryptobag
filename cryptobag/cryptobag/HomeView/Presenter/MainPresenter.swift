//
//  MainPresenter.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 12.04.2023.
//

import Foundation

protocol HomeViewDelegate: NSObjectProtocol {
    
}


class MainPresenter {
    private let dataService: DataModel
    weak private var homeViewDelegate: HomeViewDelegate?
    
    init(dataService: DataModel) {
        self.dataService = dataService
    }
    func setViewDelegate(homeViewDelegate: HomeViewDelegate?){
        self.homeViewDelegate = homeViewDelegate
    }

    func getTickers(){
        DataModel.shared.fetchDataTickers()
    }
}

