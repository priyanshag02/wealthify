//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI
import Charts

struct PortfolioView: View {
    @StateObject var coinViewModel: CryptoViewModel
    @Binding var currentHoldings: Double
    var totalHoldingsValue: Double {
        coinViewModel.portfolio.reduce(0.0) { $0 + $1.currentHoldingsValue }
    }
    var coin: CoinModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if totalHoldingsValue != 0 {
                    Chart(coinViewModel.portfolio.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }) { portfolioItem in
                        let totalPortfolioValue = coinViewModel.portfolio.reduce(0) { $0 + $1.currentHoldingsValue }
                        let angleRatio = totalPortfolioValue > 0 ? portfolioItem.currentHoldingsValue / totalPortfolioValue : 0
                        
                        SectorMark(
                            angle: .value("Coin", angleRatio),
                            innerRadius: .ratio(0.62),
                            angularInset: 2
                        )
                        .cornerRadius(6)
                        .foregroundStyle(by: .value("Coin", portfolioItem.id))
                    }
                    .chartLegend(alignment: .center)
                    .opacity(0.5)
                    .frame(width: 300, height: 300)
                    .padding()
                }
                VStack {
                    HStack (spacing: 12) {
                        Text("Total Holdings: ")
                        Text(CurrencyFormatter.formatCurrency(totalHoldingsValue))
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .frame(width: 360, height: 50)
                    .background(Color(.systemGray6).opacity(0.75), in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.vertical, 16)
                
                if totalHoldingsValue != 0 {
                    VStack {
                        HStack(spacing: 30) {
                            Text("Coin")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 100)
                            Text("Quantity")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 100)
                            Text("Net Amount")
                                .font(.headline)
                                .fontWeight(.bold)
                                .frame(width: 120)
                        }
                        
                        Divider()
                        
                        
                        ForEach(coinViewModel.portfolio.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }) { portfolio in
                            NavigationLink {
                                CoinDetailView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: portfolio.coin)
                            } label: {
                                HStack {
                                    if let coinHolding = portfolio.coin.currentHoldings {
                                        PortfolioItemView(
                                            currentHoldingsValue: portfolio.currentHoldingsValue,
                                            coinCount: coinHolding,
                                            coin: portfolio.coin
                                        )
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            Divider()
                        }
                        .padding(.horizontal, 12)
                    }
                    .padding(.top)
                }
            }
            .scrollIndicators(.never)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            coinViewModel.loadPortfolio()
        }
    }
}


#Preview {
    PortfolioView(coinViewModel: CryptoViewModel(), currentHoldings: .constant(100), coin: sampleCoinData)
}
