//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 22/02/25.
//

import SwiftUI

struct CurrentHoldingSheetView: View {
    @EnvironmentObject var coinViewModel: CryptoViewModel
    @State var currentHoldings: Double? = nil
    @State var inputHoldings: String = ""
    @Binding var showPortfolioUpdationView: Bool
    @Environment(\.colorScheme) var colorScheme
    var coin: CoinModel
    
    
    var body: some View {
        VStack(spacing: 12) {
            Divider()
            VStack (spacing: 40) {
                HStack {
                    Text("Enter Quantity")
                    Spacer()
                    TextField("", text: $inputHoldings)
                        .onChange(of: inputHoldings) { newValue in
                            if let value = Double(newValue) {
                                currentHoldings = value
                            } else {
                                currentHoldings = nil
                            }
                        }
                        .padding()
                        .keyboardType(.decimalPad)
                        .frame(width: 150)
                        .background(Color(.systemGray6).opacity(0.75), in: RoundedRectangle(cornerRadius: 12))
                }
                HStack (spacing: 30){
                    Button {
                        if let quantity = currentHoldings {
                            coinViewModel.addToPortfolio(coin: coin, coinCount: quantity)
                        }
                    } label: {
                        Text("Buy")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 50)
                            .background(.green.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 12))
                    }
                    Button {
                        if let quantity = currentHoldings {
                            coinViewModel.removeFromPortfolio(coin: coin, coinCount: quantity)
                        }
                    } label: {
                        Text("Sell")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 50)
                            .background(.red.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 12))
                    }
                    Button {
                        showPortfolioUpdationView.toggle()
                        inputHoldings = ""
                    } label: {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 50)
                            .background(.blue.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 18)
        }
        .frame(height: 225)
        .background(colorScheme == .dark ? .black : .white)
    }
}

#Preview {
    CurrentHoldingSheetView(showPortfolioUpdationView: .constant(false), coin: sampleCoinData)
}
