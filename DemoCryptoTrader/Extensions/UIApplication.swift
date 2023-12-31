//
//  UIApplication.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
