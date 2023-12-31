//
//  HomeViewModel.swift
//  DemoCryptoTrader
//
//  Created by Anand Jee Choubey on 2023-12-20.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var stats: [StatisticsModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var portfolioCoins: [CoinModel] = []
    @Published var sortOption: SortOption = .holdings
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption {
        case rank, rankReverse, holdings, holdingsReverse, price, priceReverse
    }
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (receivedCoins) in
                self?.allCoins = receivedCoins
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map (mapMarketData)
            .sink { [weak self] (data) in
                self?.stats = data
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        // update portfolio coins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map (mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
                self.portfolioCoins = self.sortCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func mapAllCoinsToPortfolioCoins(coinModels: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
        if coinModels.isEmpty {
            return []
        }
        let res = coinModels
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else {
                    return nil
                }
                
                return coin.updateHoldings(amount: entity.amount)
            }
        return res
    }
    
    private func filterAndSortCoins(text: String, startingCoins: [CoinModel], sort: SortOption) -> [CoinModel] {
        var res = filterCoins(text: text, startingCoins: startingCoins)
        sortCoins(sort: sort, coins: &res)
        return res
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return startingCoins
        }
        
        let lowecasedText = text.lowercased()
        
        return startingCoins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowecasedText) ||
                    coin.symbol.lowercased().contains(lowecasedText) ||
                    coin.id.lowercased().contains(lowecasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank:
            coins.sort(by: {$0.rank < $1.rank})
        case .rankReverse:
            coins.sort(by: {$0.rank > $1.rank})
        case .holdings:
            coins.sort { coin1, coin2 in
                return (coin1.currentHoldings ?? 0.0) < (coin2.currentHoldings ?? 0)
            }
        case .holdingsReverse:
            coins.sort { coin1, coin2 in
                return (coin1.currentHoldings ?? 0.0) > (coin2.currentHoldings ?? 0)
            }
            
        case .price:
            coins.sort(by: {$0.currentPrice > $1.currentPrice})
        case .priceReverse:
            coins.sort(by: {$0.currentPrice < $1.currentPrice})
        }
    }
    
    private func sortCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
        var sortedCoins = coins
        sortCoins(sort: sortOption, coins: &sortedCoins)
        return sortedCoins
    }
    
    private func mapMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.btcDominance)
        
        let previousValue =
            portfolioCoins
            .map { (coin) -> Double in
                let curr = coin.currentHoldingsValue
                let perChange = (coin.priceChangePercentage24H ?? 0) / 100
                return curr/(1+perChange)
            }
            .reduce(0, +)
        
        let value = portfolioCoins.map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let percentChange = portfolioCoins.isEmpty ? 0.0 : (value - previousValue)*100/previousValue
        let portfolioValue = StatisticsModel(title: "Portfolio Value", value: value.asCurrencyWith2Decimals(), percentageChange: percentChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolioValue,
        ])
        
        return stats
    }
}
