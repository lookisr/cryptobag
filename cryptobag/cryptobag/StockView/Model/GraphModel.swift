//
//  GraphModel.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 28.05.2023.
//
import Foundation
struct ResponseGraphData: Decodable {
    let high: Double
    let low: Double
}

struct Graph: Decodable {
    let prices: [Price]
    
    struct Price: Decodable {
        let date: Date
        let price: Double
    }
}
class GraphData {
    // Генерация фейковых данных для заполнения структуры Graph
    class func generateFakeData(minPrice: Double, maxPrice: Double) -> Graph {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var fakePrices = [Graph.Price]()
        
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -9, to: Date()) // Вычисляем дату начала (за 10 дней назад)
        
        for i in 0..<10 {
            let currentDate = calendar.date(byAdding: .day, value: i, to: startDate!) // Генерируем последовательные даты
            let randomPrice = Double.random(in: minPrice...maxPrice) // Генерируем случайную цену в заданном диапазоне
            
            let price = Graph.Price(date: currentDate!, price: randomPrice)
            fakePrices.append(price)
        }
        
        let graph = Graph(prices: fakePrices)
        return graph
    }

}
