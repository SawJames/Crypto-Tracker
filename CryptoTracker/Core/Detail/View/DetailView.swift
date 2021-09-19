//
//  DetailView.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 19/09/2021.
//

import SwiftUI

struct DetailLoadingView : View{
    @Binding var coin : CoinModel?
    var body: some View{
        ZStack{
            if let coin = coin {
               DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject private var vm : DetailViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View for \(coin.name)")
    }
    var body: some View {
        Text("Hello")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}
