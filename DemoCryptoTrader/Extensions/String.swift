//
//  String.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-30.
//

import Foundation


extension String {
    
    var removingHTMLOccurance: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
