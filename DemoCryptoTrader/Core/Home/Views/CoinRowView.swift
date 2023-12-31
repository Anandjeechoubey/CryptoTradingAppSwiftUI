//
//  CoinRowView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-19.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0, content: {
            leftRowView
            Spacer()
            if showHoldingsColumn {
                centerRowView
            }
            rightRowView
            
        })
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}

struct CoinRow_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
        }
        
    }
}

extension CoinRowView {
    private var leftRowView: some View {
        HStack(spacing: 0, content: {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text("\(coin.symbol.uppercased())")
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        })
    }
    
    private var centerRowView: some View {
        VStack(alignment: .trailing, content: {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        })
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightRowView: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text((coin.priceChangePercentage24H ?? 0.0).asPercentString())
                .foregroundColor(
                    (coin.priceChange24H ?? 0) < 0 ? Color.theme.red : Color.theme.green
                )
        }
        .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
    }
}
