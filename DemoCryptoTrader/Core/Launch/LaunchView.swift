//
//  LaunchView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-28.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Loading portfolio...".map { String($0) }
    @State private var showLoadingText: Bool = false
    
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool
    
    
    var body: some View {
        ZStack {
            Color.theme.launchBackground
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
            
            
            ZStack {
                if showLoadingText {
                    
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(Color.theme.launchAccent)
                                .fontWeight(.heavy)
                                .offset(y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                }
                
            }
            .offset(y: 70)
        }
        .onAppear() {
            showLoadingText.toggle()
        }
        .onReceive(timer, perform: { _ in
            withAnimation(.spring()) {
                counter += 1
                if counter > loadingText.count {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                }
            }
        })
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
