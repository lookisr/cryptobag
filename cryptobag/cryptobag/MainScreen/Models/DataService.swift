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
    func getImageURL(with id: String, completion: @escaping (Result<CoinLogo, Error>) -> Void) {
        NetworkService.shared.getData(from: "https://api.coinpaprika.com/v1/coins/\(id)") { data in
            do {
                let image = try JSONDecoder().decode(CoinLogo.self, from: data)
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func getGraphData(with id: String, completion: @escaping (Result<[ResponseGraphData], Error>) -> Void) {
        NetworkService.shared.getData(from: "https://api.coinpaprika.com/v1/coins/\(id)/ohlcv/latest") {data in
            do {
                let resp = try JSONDecoder().decode([ResponseGraphData].self, from: data)
                completion(.success(resp))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
