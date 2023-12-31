//
//  DemoCryptoTraderApp.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-19.
//

import SwiftUI

@main
struct DemoCryptoTraderApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLaunch: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            ZStack {
                NavigationView {
                    HomeView().navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                
                ZStack {
                    if showLaunch {
                        LaunchView(showLaunchView: $showLaunch)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
        }
    }
}
