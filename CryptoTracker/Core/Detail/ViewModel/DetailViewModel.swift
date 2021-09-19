//
//  DetailViewModel.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 19/09/2021.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
    private var coinDetailDataService : CoinDetailDataService
    @Published var coin : CoinModel
    
    private var cancellable = Set<AnyCancellable>()
    
    init(coin : CoinModel){
        self.coin = coin
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        self.addSubscriber()
    }
    
    private func addSubscriber(){
        coinDetailDataService.$detailCoin
            .sink { (returnedCoinDetail) in
                print(returnedCoinDetail)
            }
            .store(in: &cancellable)
    }
}
