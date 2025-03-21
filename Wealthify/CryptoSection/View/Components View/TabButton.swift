//
//  HeaderView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: Int
    let tabTitles = ["Explore", "My Portfolio", "My Watchlist"]
    let tabWidth = [UIScreen.main.bounds.width*0.25, UIScreen.main.bounds.width*0.3, UIScreen.main.bounds.width*0.3]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack (alignment: .leading) {
            Capsule()
                .fill(colorScheme == .dark ? Color(.systemGray3) : .black)
                .frame(width: selectedTab == 0 ? UIScreen.main.bounds.width*0.25 : UIScreen.main.bounds.width*0.3+10, height: 50)
                .opacity(colorScheme == .dark ? 0.4  : 0.9)
                .offset(x: selectedTab == 0 ? 0 : (selectedTab == 1 ? UIScreen.main.bounds.width*0.25 + 5 : UIScreen.main.bounds.width*0.575 + 5))
                .animation(.spring(duration: 0.35, bounce: 0.35), value: selectedTab)
            
            HStack(spacing: 10) {
                ForEach(0..<tabTitles.count, id: \.self) { index in
                    Button {
                        withAnimation (.spring()) {
                            selectedTab = index
                        }
                    } label: {
                        Text(tabTitles[index])
                            .font(.headline)
                            .frame(width: tabWidth[index], height: 50)
                            .foregroundStyle(selectedTab == index ? .white : Color(.systemGray3))
                            .contentShape(Capsule())
                    }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width*0.9, height: 60, alignment: .center)
    }
}

#Preview {
    HeaderView(selectedTab: .constant(0))
}
