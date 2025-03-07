//
//  MoneyApp.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI
import Firebase

@main
struct WealthifyApp: App {
    @State private var currentHoldings: Double = 0.0
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(coins: sampleCoinData, currentHoldings: $currentHoldings, coinViewModel: CryptoViewModel())
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(AuthViewModel())
        }
    }
}
