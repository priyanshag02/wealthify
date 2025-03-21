//
//  ContentView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct ContentView: View {
    var coin: CoinModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var coinViewModel: CryptoViewModel
    
    var body: some View {
        if authViewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .padding()
        } else {
            if authViewModel.currentUser == nil {
                AuthView(coin: coin)
            } else {
                CryptoView(coin: coin)
            }
        }
    }
}

#Preview {
    ContentView(coin: sampleCoinData)
        .environmentObject(AuthViewModel())
        .environmentObject(CryptoViewModel())
}
