//
//  ChartView.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 20/09/2021.
//

import SwiftUI

struct ChartView: View {
    private let data : [Double]
    private let maxY : Double
    private let minY : Double
    private let lineColor : Color
    private let startingDate : Date
    private let endingDate : Date
    @State private var percentage : CGFloat = 0
    
    init(coin: CoinModel){
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    //60,000 = max
    //50,000 = mmin
    //60000 - 50000 = 10000 is yAxis
    //52000 = data point
    //52000 - 50000 = 2000/10000 =20%
    
    var body: some View {
        VStack{
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYaxis.padding(.horizontal, 4)
                         , alignment: .leading)
            
            chartDateLabels.padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.linear(duration: 2.0)){
                    percentage = 1.0
                }
            }
        }
        
        
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView{
    private var chartView : some View{
        GeometryReader { geometry in
            Path{ path in
                for index in data.indices{
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index+1)
                    
                    let yAxis = maxY - minY
                    let yPosition = (1-CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }

    }
    
    private var chartBackground : some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYaxis : some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY+minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels : some View{
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
