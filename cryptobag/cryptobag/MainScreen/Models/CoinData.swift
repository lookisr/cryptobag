//
//  CoinData.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 28.04.2023.
//

import Foundation

public struct CoinLogo: Decodable {
    
    /// Coin id, eg. btc-bitcoin
    public let id: String
    
    public let logo: String
}
