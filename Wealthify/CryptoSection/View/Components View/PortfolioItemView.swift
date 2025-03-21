//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI

struct PortfolioItemView: View {
    var coin: CoinModel
    
    var body: some View {
        VStack (spacing: 1) {
            HStack {
                HStack {
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 30, height: 30)
                    
                    Text("\(coin.symbol)")
                        .textCase(.uppercase)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 60, alignment: .leading)
                }
                .padding(.horizontal, UIScreen.main.bounds.width*0.1)
                .frame(width: UIScreen.main.bounds.width*0.35, alignment: .leading)
                
                if let holding = coin.currentHoldings {
                    Text(String(format: holding != floor(holding) ? "%.2f" : "%.0f", holding))
                        .frame(width: UIScreen.main.bounds.width*0.25, alignment: .center)
                        .padding(.leading, 12)
                }
                
                if let holdingValue = coin.currentHoldingsValue {
                    Text(CurrencyFormatter.formatCurrency(holdingValue))
                        .frame(width: UIScreen.main.bounds.width*0.4, alignment: .center)
                        .padding(.trailing, 6)
                }
            }
            HStack {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .scaleEffect(y: coin.priceChange24H < 0 ? -1 : 1)
                    .opacity(coin.priceChange24H == 0 ? 0.5 : 1)
                if let holding = coin.currentHoldings {
                    if coin.priceChange24H > 0 {
                        Text(PortfolioCurrencyFormatter.formatCurrency(coin.priceChange24H * holding))
                            .font(.footnote)
                    } else {
                        Text(PortfolioCurrencyFormatter.formatCurrency(-1 * coin.priceChange24H * holding))
                            .font(.footnote)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width*0.8, alignment: .trailing)
            .padding(.trailing, 5)
            .foregroundStyle(coin.priceChange24H > 0 ? .green : (coin.priceChange24H < 0 ? .red : .gray))
        }
        .padding(.horizontal, UIScreen.main.bounds.width*0.05)
    }
}

#Preview {
    PortfolioItemView(coin: sampleCoinData)
}

struct PortfolioCurrencyFormatter {
    
    static func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = ","
        
        if value >= 1_00_00_00_00_000 {
            let lakhCr = value / 1_00_00_00_00_000
            return String(format: "%.2f L Cr", lakhCr)
        } else if value >= 10_00_00_00_000 {
            let thousandCrore = value / 10_00_00_00_000
            return String(format: "%.2f K Cr", thousandCrore)
        } else if value >= 1_00_00_000 {
            let crore = value / 1_00_00_000
            return String(format: "%.2f Cr", crore)
        } else if value >= 1_00_000 {
            let lakhs = value / 1_00_000
            return String(format: "%.2f L", lakhs)
        } else if value >= 1_000 {
            let thousand = value / 1_000
            return String(format: "%.1f K", thousand)
        } else {
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""
            return formatter.string(from: NSNumber(value: value)) ?? "0.00"
        }
    }
}
