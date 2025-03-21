//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI
import Charts

struct PortfolioView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    var totalHoldingsValue: Double {
        coinViewModel.portfolio.reduce(0.0) { $0 + $1.currentHoldingsValue }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if totalHoldingsValue != 0 {
                    Chart(coinViewModel.portfolio.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }) { portfolioItem in
                        let angleRatio = totalHoldingsValue > 0 ? portfolioItem.currentHoldingsValue / totalHoldingsValue : 0
                        let percentage = totalHoldingsValue > 0 ? (portfolioItem.currentHoldingsValue / totalHoldingsValue) * 100 : 0
                        
                        SectorMark(
                            angle: .value("Coin", angleRatio),
                            innerRadius: .ratio(0.62),
                            angularInset: 2
                        )
                        .cornerRadius(6)
                        .foregroundStyle(by: .value("Coin", "\(portfolioItem.id) (\(String(format: "%.1f", percentage))%)"))                    }
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
                                .padding(.leading, 40)
                                .frame(width: UIScreen.main.bounds.width*0.30, alignment: .center)
                            Text("Quantity")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.leading, 30)
                                .frame(width: UIScreen.main.bounds.width*0.25, alignment: .center)
                            Text("Net Amount")
                                .font(.headline)
                                .fontWeight(.bold)
                                .padding(.trailing, 10)
                            .frame(width: UIScreen.main.bounds.width*0.4, alignment: .center)                        }
                        
                        Divider()
                        
                        
                        ForEach(coinViewModel.portfolio.sorted { $0.currentHoldingsValue > $1.currentHoldingsValue }) { portfolio in
                            NavigationLink {
                                CoinDetailView(coin: portfolio.coin)
                            } label: {
                                HStack {
                                    if portfolio.coin.currentHoldings != nil {
                                        PortfolioItemView(coin: portfolio.coin)
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
    PortfolioView()
}
