//
//  SearchBarView.swift
//  Money
//
//  Created by Priyansh on 21/02/25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var coinToBeSearched: String
    
    var body: some View {
        HStack {
            HStack (spacing: 12){
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(Color(.systemGray3))
                TextField("Search your coin here", text: $coinToBeSearched)
                    .frame(height: 50)
            }
            .padding(.horizontal, 18)
            .overlay {
                Capsule()
                    .stroke(lineWidth: 2)
                    .foregroundStyle(Color(.systemGray6))
            }
            if !coinToBeSearched.isEmpty {
                Button {
                    coinToBeSearched = ""
                } label: {
                    Text("Cancel")
                }
            }
        }
    }
}

#Preview {
    SearchBarView(coinToBeSearched: .constant(""))
}
