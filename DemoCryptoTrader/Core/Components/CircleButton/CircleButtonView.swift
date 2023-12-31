//
//  CircleButtonView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-19.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
            .padding()
    }
}

#Preview {
    
    Group {
        CircleButtonView(iconName: "heart.fill")
        CircleButtonView(iconName: "info").colorScheme(.dark)
        CircleButtonView(iconName: "plus").colorScheme(.dark)
        
        CircleButtonView(iconName: "info")
        CircleButtonView(iconName: "plus")
    }
}
