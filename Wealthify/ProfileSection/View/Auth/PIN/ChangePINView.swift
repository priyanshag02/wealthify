//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct ChangePINView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                Text("To keep your account safe, we'll ask for his PIN every time you open the app.")
                    .font(.footnote)
                HStack (spacing: 12) {
                    ForEach(0...3, id: \.self) { box in
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(lineWidth: 2)
                            .foregroundStyle(Color(.systemGray3))
                            .frame(width: 60, height: 60)
                    }
                }
                
                Button {
                    
                } label: {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 50)
                        .background(.blue.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 16))
                }
                .padding(.vertical, 30)
                Spacer()
            }
            .padding(.vertical, 30)
            .padding(.horizontal)
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "arrowshape.left.fill")
                                .opacity(0.75)
                            Text("Change PIN")
                                .font(.headline)
                        }
                        .modifier(colorModifier())
                    }
                }
            }
            .navigationBarBackButtonHidden()
            
        }
    }
}

#Preview {
    ChangePINView()
}
