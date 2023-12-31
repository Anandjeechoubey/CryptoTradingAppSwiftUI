//
//  DetailViewModel.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-29.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
    
    @Published var overviewStatistics: [StatisticsModel] = []
    @Published var additionalStatistics: [StatisticsModel] = []
    @Published var coinDescription: String? = nil
    @Published var homePageLink: String? = nil
    @Published var subRedditLink: String? = nil
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapData)
            .sink { [weak self] (data) in
                self?.overviewStatistics = data.overview
                self?.additionalStatistics = data.additional
                self?.coinDescription = data.description
                self?.homePageLink = data.homePageLink
                self?.subRedditLink = data.subRedditLink
            }
            .store(in: &cancellables)
    }
    
    private func mapData(coinDetailsModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel], description: String?, homePageLink: String?, subRedditLink: String?) {
        
        let overview: [StatisticsModel] = createOverviewArray(coinModel: coinModel)
        let additional: [StatisticsModel] = createAdditionalStatsArray(coinDetailsModel: coinDetailsModel, coinModel: coinModel)
        let description = coinDetailsModel?.readableDescription ?? nil
        
        return (
            overview: overview,
            additional: additional,
            description: description,
            homePageLink: coinDetailsModel?.links?.homepage?.first,
            subRedditLink: coinDetailsModel?.links?.subredditURL
        )
    }
    
    private func createOverviewArray(coinModel: CoinModel) -> [StatisticsModel] {
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let priceChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: priceChange)
        
        let marketCap = "$\(coinModel.marketCap?.formattedWithAbbreviations() ?? "")"
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticsModel(title: "Rank", value: rank)
        
        let volume = "$\(coinModel.totalVolume?.formattedWithAbbreviations() ?? "")"
        let volumeStat = StatisticsModel(title: "Volume", value: volume)
        
        return [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
    }
    
    private func createAdditionalStatsArray(coinDetailsModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticsModel] {
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticsModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticsModel(title: "24h High", value: low)
        
        let priceChange2 = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticsModel(title: "24h Price Change", value: priceChange2, percentageChange: pricePercentChange)
        
        let marketCapChange2 = "$\(coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "n/a")"
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange2, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetailsModel?.blockTimeInMinutes ?? -1
        let blockTimeString = blockTime == -1 ? "n/a" : "\(blockTime)"
        let blockTimeStat = StatisticsModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailsModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticsModel(title: "Algorithm", value: hashing)
        
        return [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockTimeStat, hashingStat
        ]
    }
}
