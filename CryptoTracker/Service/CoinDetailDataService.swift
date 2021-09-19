//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 19/09/2021.
//

import Foundation
import Combine

class CoinDetailDataService {
    @Published var detailCoin : CoinDetailModel? = nil
    var coinDetailSubscription : AnyCancellable?
    var coin : CoinModel
    
    init(coin : CoinModel){
        self.coin = coin
        getDetailCoins()
    }
    
    func getDetailCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {return}
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion:  NetworkingManager.handleCompletion
            , receiveValue: {[weak self] (returnedDetailCoins) in
                self?.detailCoin = returnedDetailCoins
                self?.coinDetailSubscription?.cancel()
            })
            
    }
}
