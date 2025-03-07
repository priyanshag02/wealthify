//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI

struct PortfolioItemView: View {
    var currentHoldingsValue: Double
    var coinCount: Double
    var coin: CoinModel
    
    var body: some View {
        VStack (alignment: .trailing, spacing: 1) {
            HStack(alignment: .center, spacing: 30) {
                HStack (alignment: .center) {
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(width: 36, height: 36)
                    
                    Text("\(coin.symbol)")
                        .textCase(.uppercase)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .frame(width: 100, alignment: .leading)
                
                if let holding = coin.currentHoldings {
                    Text(String(format: holding != floor(holding) ? "%.2f" : "%.0f", holding))
                        .frame(width: 90, alignment: .center)
                        .padding(.leading, 12)
                }
                
                Text(CurrencyFormatter.formatCurrency(currentHoldingsValue))
                    .frame(width: 110, alignment: .center)
                    .padding(.trailing, 6)
            }
            HStack {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .scaleEffect(y: coin.priceChange24H < 0 ? -1 : 1)
                    .opacity(coin.priceChange24H == 0 ? 0.5 : 1)
                if coin.priceChange24H > 0 {
                    Text(PortfolioCurrencyFormatter.formatCurrency(coin.priceChange24H * coinCount))
                        .font(.footnote)
                } else {
                    Text(PortfolioCurrencyFormatter.formatCurrency(-1 * coin.priceChange24H * coinCount))
                        .font(.footnote)
                }
            }
            .frame(width: 330, alignment: .trailing)
            .padding(.trailing, 30)
            .foregroundStyle(coin.priceChange24H > 0 ? .green : (coin.priceChange24H < 0 ? .red : .gray))
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PortfolioItemView(currentHoldingsValue: 1231321424234, coinCount: 2, coin: sampleCoinData)
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
