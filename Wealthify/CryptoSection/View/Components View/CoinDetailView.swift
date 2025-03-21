//
//  CoinDetailView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI

struct CoinDetailView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    @State private var isBookmarked: Bool = false
    @State var showPortfolioUpdationView: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var coin: CoinModel
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .bottom){
                ScrollView {
                    VStack(spacing: 18) {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: coin.image)) { image in
                                image
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 48, height: 48)
                            } placeholder: {
                                Circle()
                                    .frame(width: 48, height: 48)
                            }
                            Text(coin.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button {
                                isBookmarked.toggle()
                                if isBookmarked {
                                    coinViewModel.addToWishlist(coin: coin)
                                    coinViewModel.saveBookmarkState(coin: coin)
                                } else {
                                    coinViewModel.removeFromWishlist(coin: coin)
                                    coinViewModel.removeBookmarkState(coin: coin)
                                }
                            } label: {
                                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                    .foregroundStyle(.white)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        if coinViewModel.portfolio.contains(where: {$0.id == coin.id}) {
                            if let currentHolding = coin.currentHoldings {
                                VStack {
                                    Text("Current Holdings")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    
                                    HStack () {
                                        VStack (alignment: .leading) {
                                            Text("Net Quantity:")
                                                .frame(height: 20)
                                            Text("Coin Holding Value:")
                                                .frame(height: 20)
                                        }
                                        .frame(width: 150)
                                        .font(.footnote)
                                        
                                        VStack (alignment: .leading) {
                                            Text(String(format: "%.1f", currentHolding))
                                                .frame(height: 20)
                                            if let holdingsValue = coin.currentHoldingsValue {
                                                Text(CurrencyFormatter.formatCurrency(holdingsValue))
                                                    .frame(height: 20)
                                            }
                                        }
                                        .frame(width: 125, height: 30)
                                        .font(.headline)
                                    }
                                }
                                .padding()
                                .frame(width: 325, height: 110)
                                .background(Color(.systemGray6).opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 24)
                        
                        Divider()
                        
                        HStack(alignment: .top, spacing: 18) {
                            VStack(alignment: .leading, spacing: 30) {
                                AmountSectionView(title: "Current Price", parameterValue: coin.currentPrice)
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading) {
                                        Text("Market Cap Rank")
                                            .font(.headline)
                                            .foregroundStyle(Color(.systemGray))
                                        Text("\(coin.marketCapRank)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                }
                                AmountSectionView(title: "24h High", parameterValue: coin.high24H)
                                AmountSectionView(title: "24h Price Change", parameterValue: coin.priceChange24H)
                                    .foregroundStyle(coin.priceChange24H > 0 ? .green : .red)
                            }
                            .frame(width: 180)
                            
                            VStack(alignment: .leading, spacing: 30) {
                                AmountSectionView(title: "Market Capitalization", parameterValue: coin.marketCap)
                                AmountSectionView(title: "Volume", parameterValue: coin.totalVolume)
                                AmountSectionView(title: "24h Low", parameterValue: coin.low24H)
                                AmountSectionView(title: "24h Cap Change", parameterValue: coin.marketCapChange24H)
                                    .foregroundStyle(coin.marketCapChange24H > 0 ? .green : .red)
                            }
                            .frame(width: 180)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 18)
                        .font(.headline)
                        
                        Button {
                            withAnimation (.smooth) {
                                showPortfolioUpdationView.toggle()
                            }
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
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .modifier(colorModifier())
                        }
                    }
                }
                .scrollIndicators(.never)
                .navigationBarBackButtonHidden()
                if showPortfolioUpdationView {
                    CurrentHoldingSheetView(showPortfolioUpdationView: $showPortfolioUpdationView, coin: coin)
                        .animation(.easeInOut(duration: 5), value: showPortfolioUpdationView)
                }
            }
            .onAppear {
                coinViewModel.loadPortfolio()
                isBookmarked = coinViewModel.loadBookmarkState(coin: coin)
            }
        }
    }
}

#Preview {
    CoinDetailView(coin: sampleCoinData)
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

