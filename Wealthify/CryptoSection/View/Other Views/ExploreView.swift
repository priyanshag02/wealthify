//
//  ExploreView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct ExploreView: View {
    @ObservedObject var coinViewModel: CryptoViewModel
    @Binding var currentHoldings: Double
    var coins: CoinModel
    let column: [GridItem] = [GridItem(.flexible(), spacing: 6),
                              GridItem(.flexible(), spacing: 6)]
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVGrid (columns: column, spacing: 18) {
                    ForEach(coinViewModel.topCoins){topCoin in
                        NavigationLink {
                            CoinDetailView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: topCoin)
                        } label: {
                            GlimpseView(coinViewModel: coinViewModel, coin: topCoin)
                                .foregroundStyle(.white)
                        }
                    }
                    
                    NavigationLink {
                        CryptoListView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: coins)
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
        }
    }
}

#Preview {
    ExploreView(coinViewModel: CryptoViewModel(), currentHoldings: .constant(0.456), coins: sampleCoinData)
}
