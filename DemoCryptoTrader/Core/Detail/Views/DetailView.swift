//
//  DetailView.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-29.
//

import SwiftUI

struct DetailLoadingView: View {
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    @State private var showFullDesc: Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    var body: some View {
        ScrollView {
            ChartView(coin: vm.coin)
                .padding(.vertical)
            VStack {
                VStack(spacing: 20, content: {
                    
                    overViewStatsHeader
                    
                    Divider()
                    
                    descriptionSection
                    overViewStats
                    
                    additionalStatsHeader
                    
                    Divider()
                    additionalStatView
                    
                    Divider()
                    linksSection
                })
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                    .foregroundColor(Color.theme.secondaryText)
                    
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
            }
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    
    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let website = vm.homePageLink,
            let url = URL(string: website) {
                Link("Website", destination: url)
            }
            
            if let redditLink = vm.subRedditLink,
            let url = URL(string: redditLink) {
                Link("Reddit", destination: url)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var descriptionSection: some View {
        ZStack {
            if let description = vm.coinDescription,
               !description.isEmpty {
                VStack(alignment: .leading) {
                    
                    
                    Text(description)
                        .lineLimit(showFullDesc ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut) {
                            showFullDesc.toggle()
                        }
                    } label: {
                        Text(showFullDesc ? "Less" : "Read more...")
                            .fontWeight(.bold)
                            .font(.caption)
                            .padding(.vertical)
                    }
                    .accentColor(.blue)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var overViewStats: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
        
    }
    
    private var additionalStatView: some View {
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: spacing, pinnedViews: [], content: {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(stat: stat)
            }
        })
        
    }
    
    private var overViewStatsHeader: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalStatsHeader: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
