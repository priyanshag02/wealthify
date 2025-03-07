//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct AuthView: View {
    @State var selectedAuth: Int = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var coinViewModel: CryptoViewModel
    @Binding var currentHoldings: Double
    var coin: CoinModel
    
    var body: some View {
        if authViewModel.currentUser != nil {
            CryptoView(coinViewModel: coinViewModel, currentHoldings: $currentHoldings, coins: coin)
        } else {
            if selectedAuth == 0 {
                LoginView(selectedAuth: $selectedAuth)
            } else {
                SignUpView(selectedAuth: $selectedAuth)
            }
        }
    }
}

#Preview {
    AuthView(coinViewModel: CryptoViewModel(), currentHoldings: .constant(0.456), coin: sampleCoinData)
        .environmentObject(AuthViewModel())
}
