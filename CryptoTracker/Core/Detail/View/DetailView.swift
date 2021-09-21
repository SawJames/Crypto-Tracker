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
    @State private var showFullDescription : Bool = false
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
                VStack{
                    ChartView(coin: vm.coin)
                        .padding(.vertical)
                    
                    detailOverView
                    descriptionSection
                    Divider()
                    overviewGrid
                    
                    detailAdditionalView
                    Divider()
                    additionalGrid
                
                    
                    VStack(alignment: .leading, spacing: 20){
                        if let websiteString = vm.websiteURL,
                           let url = URL(string: websiteString){
                            Link("Website", destination: url)
                        }
                        
                        if let redditString = vm.redditURL,
                           let url = URL(string: redditString){
                            Link("Reddit", destination: url)
                        }
                    }
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
                }
               
           
            }
            .padding()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(vm.coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(Color.theme.secondaryText)
                    CoinImageView(coin: vm.coin)
                        .frame(width: 25, height: 25)
                }
            }
        }
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
    
    private var descriptionSection : some View{
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                
                VStack(alignment: .leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text(showFullDescription ? "Read Less" : "Read More")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
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
