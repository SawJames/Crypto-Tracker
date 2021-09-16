//
//  homeViewModel.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 16/09/2021.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    init(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubscribers()
    }
    
    private func addSubscribers(){
        dataService.$allCoins
            .sink { (returnedCoins) in
                self.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
    }
    
}
