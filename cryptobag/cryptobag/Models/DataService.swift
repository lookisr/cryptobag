//
//  DataModel.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 12.04.2023.
//

import Foundation

class DataModel {
    
    public static let shared = DataModel()
    
    
    func fetchDataTickers(completion: @escaping ([Ticker]) -> Void) {
        NetworkService.shared.getData(from: "https://api.coinpaprika.com/v1/tickers") {data in
            let tickers = try! JSONDecoder().decode([Ticker].self, from: data)            
            completion(tickers)
        }
        
    }
}
