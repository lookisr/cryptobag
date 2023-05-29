////
////  CoinsModel.swift
////  cryptobag
////
////  Created by Rafael Shamsutdinov on 24.04.2023.
////
//
//import Foundation
//import UIKit
//
//
//protocol TickerDataProtocol {
//    var id: String {get}
//    var price: String {get}
//    var name: String {get}
//    var symbol: String {get}
//    var change1d: String {get}
//}
//
//
//class CoinsDataModel: TickerDataProtocol {
//    private let stock: Ticker
//    init(stock: Ticker){
//        self.stock = stock
//    }
//    var id: String {
//        stock.id
//    }
//
//    var price: String {
//        "\(stock.quotes.first?.value.price ?? 1)"
//    }
//    
//    var name: String {
//        stock.name
//    }
//
//    var symbol: String {
//        stock.symbol
//    }
//
//    var change1d: String {
//        "\(stock.quotes.first?.value.percentChange24h ?? 0)"
//    }
//
//
//}
