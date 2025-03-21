//
//  CryptoListView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct CryptoListView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    @State private var coinToBeSearched: String = ""
    @State private var selectedSortingOption: Int = 0
    @Environment(\.dismiss) var dismiss
    var coin: CoinModel
    
    
    var sortedCoins: [CoinModel] {
        switch selectedSortingOption {
        case 0:
            return coinViewModel.coins.sorted { $0.marketCap > $1.marketCap }
        case 1:
            return coinViewModel.coins.sorted { $0.marketCap < $1.marketCap }
        case 2:
            return coinViewModel.coins.sorted { $0.totalVolume > $1.totalVolume }
        case 3:
            return coinViewModel.coins.sorted { $0.currentPrice > $1.currentPrice }
        case 4:
            return coinViewModel.coins.sorted { $0.currentPrice < $1.currentPrice }
        case 5:
            return coinViewModel.coins.sorted { $0.name < $1.name }
        default:
            return coinViewModel.coins.sorted { $0.name > $1.name }
        }
    }
    
    var searchedCoins: [CoinModel] {
        guard !coinToBeSearched.isEmpty else { return sortedCoins }
        return sortedCoins.filter { $0.symbol.localizedCaseInsensitiveContains(coinToBeSearched) || $0.name.localizedCaseInsensitiveContains(coinToBeSearched) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 18) {
                    SearchBarView(coinToBeSearched: $coinToBeSearched)
                        .padding(.horizontal, 12)
                    SortingView(selectedSortingOption: $selectedSortingOption)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 18)
                    ScrollView {
                        ForEach (searchedCoins) { coin in
                            NavigationLink(destination: CoinDetailView(coin: coin)) {
                                CoinRowView(coin: coin)
                                    .padding(.horizontal, 18)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                                .padding(.vertical, 8)
                        }
                    }
                    .scrollIndicators(.never)
                }
                .padding(.top, 12)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack (spacing: 12){
                                Image(systemName: "arrow.left")
                                Text("All Coins")
                                    .font(.headline)
                            }
                            .modifier(colorModifier())
                        }
                    }
                }
            }
        }
        .onAppear {
            coinViewModel.loadData()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    CryptoListView(coin: sampleCoinData)
}
