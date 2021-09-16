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
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoin)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
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
    
}
