//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 19/09/2021.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
    
    @Published var overViewStatistics : [StatisticModel] = []
    @Published var additionalStatistics : [StatisticModel] = []
    @Published var coin : CoinModel
    @Published var coinDescription : String? = nil
    @Published var websiteURL : String? = nil
    @Published var redditURL : String? = nil
    
    private let coinDetailDataService : CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin : CoinModel){
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscriber()
    }
    
    private func addSubscriber(){
        coinDetailDataService.$detailCoin
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self](returnedCoinDetail) in
                self?.overViewStatistics = returnedCoinDetail.overview
                self?.additionalStatistics = returnedCoinDetail.additional
            }
            .store(in: &cancellable)
        
        coinDetailDataService.$detailCoin
            .sink { [weak self](returnDescription) in
                self?.coinDescription = returnDescription?.readableDescription
                self?.websiteURL = returnDescription?.links?.homepage?.first
                self?.redditURL = returnDescription?.links?.subredditURL 
            }
            .store(in: &cancellable)
    }
    
    private func mapDataToStatistic(coinDetailModel : CoinDetailModel?, coinModel: CoinModel)-> (overview: [StatisticModel], additional: [StatisticModel]){
        let overviewArray = createOverViewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        return (overviewArray, additionalArray)
    }
    
    func createOverViewArray(coinModel: CoinModel)-> [StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Vloume", value: volume)
        
        let overviewArray : [StatisticModel] = [priceStat, marketCapStat, rankStat, volumeStat]
        return overviewArray
    }
    
    func createAdditionalArray(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> [StatisticModel]{
        //additional
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h Hight", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Changwe", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange2 = coinModel.marketCapChange24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentageChange2)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStats = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat ,blockStats, hashingStat
        ]
        
        return additionalArray
    }
}
