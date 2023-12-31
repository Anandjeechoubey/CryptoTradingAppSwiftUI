//
//  SettingsView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-28.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let linkedInURL = URL(string: "https://www.linkedin.com/in/anand-jee-choubey/")!
    let portfolioURL = URL(string: "https://www.anandjeechoubey.com/")!
    let twitterURL = URL(string: "https://twitter.com/AnandJeeChoube1")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    
    var body: some View {
        NavigationView {
            List {
                introSection
                coinGeckoSection
                developerIntroSection
                applicationSection

            }
            .font(.headline)
            .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .navigationTitle("Settings")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            })
        }
    }
}

extension SettingsView {
    
    private var introSection: some View {
        Section {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This is a demo project app created with sole purpose of learning SwiftUI. It uses MVVM architechture, Combine and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link(destination: linkedInURL) {
                Text("Find me on LinkedIn")
            }
        } header: {
            Text("Demo Crypto Trader")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data that is used in this App comes from a free API CoinGecko!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link(destination: coingeckoURL) {
                Text("Visit CoinGecko Website")
            }
        } header: {
            Text("Coin Gecko")
        }
    }
    
    private var developerIntroSection: some View {
        Section {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app is Developed by Anand. It uses SwiftUI and is written 100% in Swift. This project benifits from multi-threading, publishers/subscribers and the data persistance!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link(destination: linkedInURL) {
                Text("Find me on LinkedIn")
            }
        } header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link(destination: defaultURL) {
                Text("Terms of Service")
            }
            Link(destination: defaultURL) {
                Text("Privacy Policy")
            }
            Link(destination: defaultURL) {
                Text("Company Website")
            }
            Link(destination: defaultURL) {
                Text("Learn More")
            }
        }
    }
}

#Preview {
    SettingsView()
}
