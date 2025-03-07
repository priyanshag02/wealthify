//
//  Extra.swift
//  Money
//
//  Created by Priyansh on 01/03/25.
//

import Foundation
import SwiftUI

struct colorModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body (content: Content) -> some View {
        content
            .foregroundStyle(colorScheme == .dark ? .white : .black)
    }
}

struct PasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var fieldTitle: String
    @Binding var value: String
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .font(.footnote)
                .padding(.leading, 12)
            SecureField(fieldTitle, text: $value)
                .padding()
                .frame(height: 50)
                .background(Color(.systemGray6).opacity(colorScheme == .dark ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct CredentialElementView: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var fieldTitle: String
    @Binding var value: String
    
    var body: some View {
        VStack (alignment: .leading){
            Text(title)
                .font(.footnote)
                .padding(.horizontal, 12)
            TextField(fieldTitle, text: $value)
                .padding()
                .frame(height: 50)
                .background(Color(.systemGray6).opacity(colorScheme == .dark ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 16))
        }
    }
}

