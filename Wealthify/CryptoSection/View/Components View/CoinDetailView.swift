//
//  CoinDetailView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI

struct CoinDetailView: View {
    @ObservedObject var coinViewModel: CryptoViewModel
    @State private var isBookmarked: Bool = false
    @Binding var currentHoldings: Double
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var showPortfolioUpdationView: Bool = false
    var coins: CoinModel
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom){
                ScrollView {
                    VStack(spacing: 18) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: coins.image)) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            } placeholder: {
                                Circle()
                                    .frame(width: 48, height: 48)
                            }
                            Text(coins.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button {
                                isBookmarked.toggle()
                                if isBookmarked {
                                    coinViewModel.addToWishlist(coin: coins)
                                    coinViewModel.saveBookmarkState(coin: coins)
                                } else {
                                    coinViewModel.removeFromWishlist(coin: coins)
                                    coinViewModel.removeBookmarkState(coin: coins)
                                }
                            } label: {
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                        
                        Divider()
                        
                        HStack(alignment: .top, spacing: 18) {
                            VStack(alignment: .leading, spacing: 30) {
                                AmountSectionView(title: "Current Price", parameterValue: coins.currentPrice)
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading) {
                                        Text("Market Cap Rank")
                                            .font(.headline)
                                            .foregroundStyle(Color(.systemGray))
                                        Text("\(coins.marketCapRank)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                }
                                AmountSectionView(title: "24h High", parameterValue: coins.high24H)
                                AmountSectionView(title: "24h Price Change", parameterValue: coins.priceChange24H)
                                    .foregroundStyle(coins.priceChange24H > 0 ? .green : .red)
                            }
                            .frame(width: 180)
                            
                            VStack(alignment: .leading, spacing: 30) {
                                AmountSectionView(title: "Market Capitalization", parameterValue: coins.marketCap)
                                AmountSectionView(title: "Volume", parameterValue: coins.totalVolume)
                                AmountSectionView(title: "24h Low", parameterValue: coins.low24H)
                                AmountSectionView(title: "24h Cap Change", parameterValue: coins.marketCapChange24H)
                                    .foregroundStyle(coins.marketCapChange24H > 0 ? .green : .red)
                            }
                            .frame(width: 180)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 18)
                        .font(.headline)
                        
                        Button {
                            showPortfolioUpdationView.toggle()
                        } label: {
                            Text("Manage Portfolio")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 180, height: 50)
                                .background(colorScheme == .dark ? .blue.opacity(0.5) : .blue, in: RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    .padding(.top)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "arrowshape.left.fill")
                                .opacity(0.75)
                                .modifier(colorModifier())
                        }
                    }
                }
                .scrollIndicators(.never)
                .navigationBarBackButtonHidden()
                if showPortfolioUpdationView {
                    CurrentHoldingSheetView(coinViewModel: coinViewModel, showPortfolioUpdationView: $showPortfolioUpdationView, coin: coins)
                        .animation(.easeInOut(duration: 5), value: showPortfolioUpdationView)
                }
            }
            .onAppear(perform: {
                coinViewModel.loadPortfolio()
                isBookmarked = coinViewModel.loadBookmarkState(coin: coins)
            })
            
        }
    }
}

#Preview {
    CoinDetailView(coinViewModel: CryptoViewModel(), currentHoldings: .constant(0.456), coins: sampleCoinData)
}

struct AmountSectionView: View {
    var title: String
    var parameterValue: Double
    var changeValue: Double?
    var changePer: Double?
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .font(.headline)
                .foregroundStyle(Color(.systemGray))
            Text(parameterValue > 0 ? (parameterValue < 999 ? String(format: "₹ %.3f", parameterValue) : CurrencyFormatter.formatCurrency(parameterValue)) :
                    (-1*parameterValue < 999 ? String(format: "₹ %.3f", -1*parameterValue) : CurrencyFormatter.formatCurrency(-1*parameterValue)))
            .font(.title2)
            .fontWeight(.bold)
            HStack (alignment: .center, spacing: 6) {
                if let changeValue = changeValue {
                    Text(changeValue > 0 ? CurrencyFormatter.formatCurrency(changeValue) : CurrencyFormatter.formatCurrency(-1*changeValue))
                        .font(.subheadline)
                        .foregroundStyle(changeValue > 0 ? .green : (changeValue == 0 ? Color(.systemGray4) : .red))
                }
                if let changePer = changePer {
                    Text(String(format: "(%.2f %%)", changePer > 0 ? changePer : -1 * changePer))
                        .font(.subheadline)
                        .foregroundStyle(changePer > 0 ? .green : (changePer == 0 ? Color(.systemGray4) : .red))
                }
            }
        }
    }
}

