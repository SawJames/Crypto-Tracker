//
//  SettingView.swift
//  CryptoTracker
//
//  Created by saw Tarmalar on 21/09/2021.
//

import SwiftUI

struct SettingView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com/c/swiftfulthinking")!
    let coffeeURL = URL(string: "https://buymecoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com/en")!
    let personalURL = URL(string: "https://www.nicksarno.com")!
    
    var body: some View {
        NavigationView{
            List{
                swiftulThinkingSection
                coinGeckoSection
                applicationSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Setting")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
            })
        }
        
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

extension SettingView{
    private var swiftulThinkingSection : some View {
        Section(header: Text("Swiftful Thinking")) {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwfitfulThinking course on Youtube. It uses MVVM Architecture, Combine, and CoreData")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on Youtube 😀", destination: youtubeURL)
            Link("Support his coffee addition ☕️", destination: coffeeURL)
        }
    }
    
    private var coinGeckoSection : some View {
        Section(header: Text("Coin Gecko")) {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This cryptocurrency data that is used in this app come from a free API from CoinGecko. Price may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Coingecko 🦎", destination: coingeckoURL)
           
        }
    }
    
    private var applicationSection : some View{
        Section(header: Text("Application")) {
            Link("Term of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}
