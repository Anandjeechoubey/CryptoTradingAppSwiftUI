//
//  Color.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-19.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    let launchBackground = Color("LaunchBackgroundColor")
    let launchAccent = Color("LaunchAccentColor")
}
