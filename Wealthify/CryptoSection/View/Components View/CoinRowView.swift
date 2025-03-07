//
//  CoinRowView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct CoinRowView: View {
    var coin: CoinModel
    
    var body: some View {
        HStack {
            HStack (spacing: 12){
                AsyncImage(url: URL(string: coin.image)) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                }
                .frame(width: 36, height: 36)

                Text(coin.symbol.uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Spacer()
            VStack (alignment: .trailing, spacing: 4) {
                Text(coin.currentPrice, format: .currency(code: "inr"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                HStack {
                    Image(systemName: "triangle.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .scaleEffect(y: coin.priceChangePercentage24H < 0 ? -1 : 1)
                        .opacity(coin.priceChangePercentage24H == 0 ? 0.5 : 1)
                    Text(coin.priceChangePercentage24H > 0 ? String(format: "%.2f %%", coin.priceChangePercentage24H) : String(format: "%.2f %%", -1*coin.priceChangePercentage24H))
                        .font(.footnote)
                }
                .foregroundStyle(coin.priceChangePercentage24H > 0 ? .green : (coin.priceChangePercentage24H < 0 ? .red : .primary))
                .padding(.horizontal, 6)
            }
        }
    }
}

#Preview {
    CoinRowView(coin: sampleCoinData)
}
