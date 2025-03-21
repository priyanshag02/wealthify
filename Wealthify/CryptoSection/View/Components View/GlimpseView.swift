//
//  GlimpseView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct GlimpseView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    var coin: CoinModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
            VStack (spacing: 12) {
                HStack {
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image.resizable()
                            .frame(width: 42, height: 42)
                    } placeholder: {
                        Circle()
                            .frame(width: 42, height: 42)
                    }
                    Text(coin.symbol.uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 6)
                VStack (alignment: .leading, spacing: 6) {
                    Text(coin.currentPrice, format: .currency(code: "inr"))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(coin.priceChange24H > 0 ? String(format: "+ %.2f", coin.priceChange24H) : String(format: "- %.2f", -1*coin.priceChange24H))
                        Text(String(format: "(%.2f %%)", coin.priceChangePercentage24H > 0 ? coin.priceChangePercentage24H : -1 * coin.priceChangePercentage24H))
                    }
                    .padding(.horizontal, 8)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(coin.priceChange24H > 0 ? .green : (coin.priceChange24H == 0 ? .white : .red))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .modifier(colorModifier())
            .frame(width: 175, height: 125, alignment: .leading)
            .padding(3)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color(.systemGray6)).opacity(colorScheme == .dark ? 0.5 : 0.8)
            }
            .onAppear {
                coinViewModel.loadData()
            }
        }
}

#Preview {
    GlimpseView(coin: sampleCoinData)
}
