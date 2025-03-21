//
//  ExploreView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    var coin: CoinModel
    let column: [GridItem] = [GridItem(.flexible(), spacing: 6),
                              GridItem(.flexible(), spacing: 6)]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid (columns: column, spacing: 18) {
                    ForEach(coinViewModel.topCoins){topCoin in
                        NavigationLink {
                            CoinDetailView(coin: topCoin)
                        } label: {
                            GlimpseView(coin: topCoin)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    NavigationLink {
                        CryptoListView(coin: coin)
                    } label: {
                        VStack (spacing: 16){
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("All Coins")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(width: 175, height: 125)
                        .padding(3)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundStyle(Color(.systemGray6).opacity(0.5))
                        }
                    }
                }
                .padding(.horizontal, 6)
            }
            .padding(.top)
        }
        .onAppear {
            coinViewModel.loadData()
            coinViewModel.loadPortfolio()
        }
    }
}

#Preview {
    ExploreView(coin: sampleCoinData)
}
