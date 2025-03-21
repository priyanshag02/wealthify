//
//  CredentialElementView.swift
//  Wealthify
//
//  Created by Priyansh on 18/03/25.
//

import SwiftUI


struct CredentialElementView: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var fieldTitle: String
    @Binding var value: String
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
            TextField(fieldTitle, text: $value)
                .padding()
                .frame(height: 50)
                .background(Color(.systemGray6).opacity(colorScheme == .dark ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
