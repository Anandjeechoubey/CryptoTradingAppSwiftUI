//
//  HapticManager.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-29.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
