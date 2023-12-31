//
//  ChartView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-30.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let endDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        lineColor = (data.last ?? 0) > (data.first ?? 0) ? Color.theme.green : Color.theme.red
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        VStack {
            geometryReader
                .frame(height: 200)
                .background(
                    VStack {
                        Divider()
                        Spacer()
                        Divider()
                        Spacer()
                        Divider()
                    }
                )
                .overlay(
                    VStack {
                        Text(maxY.formattedWithAbbreviations())
                        Spacer()
                        let price = (maxY + minY) / 2
                        Text(price.formattedWithAbbreviations())
                        Spacer()
                        Text(minY.formattedWithAbbreviations())
                    }
                        .font(.caption2)
                        .foregroundColor(Color.theme.secondaryText)
                        .padding(.horizontal, 4)
                    , alignment: .leading
                )
            
            HStack {
                Text(startDate.asShortDateString())
                Spacer()
                Text(endDate.asShortDateString())
            }
            .font(.caption2)
            .foregroundColor(Color.theme.secondaryText)
            .padding(.horizontal, 4)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation(.linear(duration: 1.0)) {
                    percentage = 1.0
                }
            })
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    
    private var geometryReader: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let x = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    let y = geometry.size.height - CGFloat((data[index] - minY)/yAxis) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    }
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, y: 10 )
            .shadow(color: lineColor.opacity(0.5), radius: 10, y: 20 )
            .shadow(color: lineColor.opacity(0.2), radius: 10, y: 30 )
            .shadow(color: lineColor.opacity(0.1), radius: 10, y: 40 )
        }
    }
}
