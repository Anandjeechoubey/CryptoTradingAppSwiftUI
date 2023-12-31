//
//  StatisticsModel.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-22.
//

import Foundation

struct StatisticsModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
