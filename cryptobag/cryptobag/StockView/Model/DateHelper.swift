//
//  DateHelper.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 01.06.2023.
//

import Foundation
import Charts


class WeekdayAxisValueFormatter: NSObject, AxisValueFormatter {
    let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value) % weekdays.count
        return weekdays[index]
    }
}


