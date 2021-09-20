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
    private let column : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing : CGFloat = 30
    
    init(coin: CoinModel){
       _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail view for \(coin.name)")
    }
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                Text("")
                    .frame(height: 150)
                
                detailOverView
                Divider()
                overviewGrid
                
                detailAdditionalView
                Divider()
                additionalGrid
           
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(coin: dev.coin)
        }
       
    }
}

extension DetailView{
    private var detailOverView : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var detailAdditionalView : some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid : some View{
        LazyVGrid(
            columns: column,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.overViewStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
    
    private var additionalGrid : some View{
        LazyVGrid(
            columns: column,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: [],
            content: {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
        })
    }
}
