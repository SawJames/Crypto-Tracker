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
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var isLoading : Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
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
        
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{(coinModels, porfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = porfolioEntities.first(where: {$0.coinId == coin.id}) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self](returnedCoin) in
                self?.portfolioCoins = returnedCoin
            }
            .store(in: &cancellables)
        
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self](returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        
        
        
    }
    
    public func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success) //to vibrate the device
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
    
    private func mapGlobalMarketData(marketDataModel : MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue = portfolioCoins.map { (coin) -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H! / 100
            let previousValue = currentValue / (1+percentChange)
            return previousValue
        }
        .reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / previousValue) *  100
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
    
}
