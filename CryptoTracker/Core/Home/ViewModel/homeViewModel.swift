//
//  homeViewModel.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 16/09/2021.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var statistics : [StatisticModel] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var isLoading : Bool = false
    
    @Published var searchText : String = ""
    
    init(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    
    private func addSubscribers(){
//        dataService.$allCoins
//            .sink { (returnedCoins) in
//                self.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
        
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self](returnedStats) in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
        
    }
    
    private func filterCoin(text: String, coins: [CoinModel]) -> [CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        let lowercaseText = text.lowercased()
        return coins.filter { (coin)-> Bool in
            return coin.name.lowercased().contains(lowercaseText) ||
                coin.symbol.lowercased().contains(lowercaseText) ||
                coin.id.lowercased().contains(lowercaseText)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel : MarketDataModel?) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
