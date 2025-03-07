//
//  ContentView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct ContentView: View {
    var coins: CoinModel
    @Binding var currentHoldings: Double
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var coinViewModel: CryptoViewModel
    
    var body: some View {
        if authViewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .padding()
        } else {
            if authViewModel.currentUser == nil {
                AuthView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coin: coins)
            } else {
                CryptoView(coinViewModel: CryptoViewModel(), currentHoldings: $currentHoldings,  coins: coins)
            }
        }
    }
}

#Preview {
    ContentView(coins: sampleCoinData, currentHoldings: .constant(0.456), coinViewModel: CryptoViewModel())
        .environmentObject(AuthViewModel())
}
