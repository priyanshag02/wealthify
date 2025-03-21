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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @StateObject private var coinViewModel = CryptoViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(coin: sampleCoinData)
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environmentObject(AuthViewModel())
                .environmentObject(CryptoViewModel())
        }
    }
}
