//
//  PortfolioView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-22.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinListView
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                    
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading, content: {
                    XMarkButton()
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    trailingNavBarButtons
                })
            })
            .onChange(of: vm.searchText, perform: { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    private var coinListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings {
            quantityText = "\(amount)"
        } else {
            quantityText = ""
        }
    }
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0;
        
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20, content: {
            HStack {
                Text("The current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                 Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack {
                Text("Amount in you portfolio:")
                Spacer()
                TextField("Ex. 12.34", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        })
        .padding()
    }
    
    private var trailingNavBarButtons: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0: 0.0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(
                selectedCoin != nil && Double(quantityText) != selectedCoin?.currentHoldings ? 1.0 : 0.0
            )

        }
    }
    
    private func saveButtonPressed() {
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        // update portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        })
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
