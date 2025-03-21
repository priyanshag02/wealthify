//
//  CryptoView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct CryptoView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var coinViewModel: CryptoViewModel
    @Environment(\.colorScheme) var colorScheme
    var coin: CoinModel
    
    var body: some View {
        NavigationStack {
            Divider()
            VStack (spacing: 18){
                HeaderView(selectedTab: $selectedTab)
                if selectedTab == 0 {
                    ExploreView(coin: coin)
                } else if selectedTab == 1 {
                    PortfolioView()
                }
                else {
                    WatchlistView(coin: coin)
                }
            }
            .onAppear {
                coinViewModel.loadData()
                coinViewModel.loadPortfolio()
            }
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    HStack (spacing: 6){
                        Image(colorScheme == .dark ? "whiteIcon" : "blackIcon")
                            .resizable()
                            .frame(width: 36, height: 36)
                        Text("Wealthify")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .modifier(colorModifier())
                    }
                }
            }
            .padding(.vertical, 12)
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    CryptoView(coin: sampleCoinData)
}
