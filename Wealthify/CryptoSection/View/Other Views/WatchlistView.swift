//
//  WatchlistView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct WatchlistView: View {
    @ObservedObject var coinViewModel: CryptoViewModel
    @Binding var currentHoldings: Double
    var coin: CoinModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if !coinViewModel.wishlist.isEmpty {
                    HStack {
                        Text("Coin")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 100)
                        Spacer()
                        Text("Price")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 120)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    ForEach (coinViewModel.wishlist) { coin in
                        NavigationLink(destination: CoinDetailView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: coin)) {
                            CoinRowView(coin: coin)
                                .padding(.horizontal, 18)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Divider()
                            .padding(.vertical, 8)
                    }
                } else {
                    NavigationLink(destination: CryptoListView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: coin)) {
                        HStack (spacing: 12) {
                            Text("Add coins to your watchlist")
                                .font(.headline)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 10, height: 10)
                        }
                        .foregroundStyle(Color(.systemGray2))
                        .padding()

                    }
                }
            }
        }
        .onAppear() {
            coinViewModel.loadWishlist()
        }
    }
}

#Preview {
    WatchlistView(coinViewModel: CryptoViewModel(), currentHoldings: .constant(0.456), coin: sampleCoinData)
}
