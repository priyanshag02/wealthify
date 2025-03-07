//
//  HeaderView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct HeaderView: View {
    @Binding var selectedTab: Int
    @Namespace private var animation
    let tabTitles = ["Explore", "My Portfolio", "My Watchlist"]
    let buttonWidths: [CGFloat] = [80, 120, 120]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<tabTitles.count, id: \.self) { index in
                Button {
                    withAnimation (.spring()) {
                        selectedTab = index
                    }
                } label: {
                    Text(tabTitles[index])
                        .font(.headline)
                        .frame(width: buttonWidths[index], height: 50)
                        .padding(.horizontal, 6)
                        .foregroundStyle(selectedTab == index ? .white : Color(.systemGray3))
                        .contentShape(Capsule())
                        .background {
                            if selectedTab == index {
                                Capsule()
                                    .fill(colorScheme == .dark ? Color(.systemGray3) : .black)
                                    .opacity(colorScheme == .dark ? 0.4  : 0.9)
                                    .matchedGeometryEffect(id: "tab", in: animation)
                            }
                        }
                }
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    HeaderView(selectedTab: .constant(0))
}
