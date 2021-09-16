//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 16/09/2021.
//

import SwiftUI

struct CoinRowView: View {
    let coin : CoinModel
    let showHoldingsColumn : Bool
    var body: some View {
        HStack{
            leftCloumn
            Spacer()
            if showHoldingsColumn{
                centerColumn
            }
            rightColumn
            
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.01)
        )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(coin: dev.coin, showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingsColumn: false)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
       
    }
}

extension CoinRowView {
    private var leftCloumn : some View {
        HStack{
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn : some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
    }
    
    
    private var rightColumn : some View {
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith2Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
