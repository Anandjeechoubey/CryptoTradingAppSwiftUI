//
//  CircleButtonAnimation.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-19.
//

import SwiftUI

struct CircleButtonAnimation: View {
    @Binding var animate: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animate ? /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/ : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(Animation.easeOut(duration: 1.0), value: animate)
    }
}

#Preview {
    CircleButtonAnimation(animate: .constant(false))
        .foregroundColor(.red)
        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
}
