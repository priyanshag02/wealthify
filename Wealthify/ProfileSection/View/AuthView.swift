//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct AuthView: View {
    var title: [String] = ["Login", "Sign Up"]
    @State var selectedAuth: Int = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var coinViewModel: CryptoViewModel
    var coin: CoinModel
    
    var body: some View {
        if authViewModel.currentUser != nil {
            CryptoView(coin: coin)
        } else {
            VStack (spacing: 50) {
                ZStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.black)
                        .frame(width: UIScreen.main.bounds.width * 0.3, height: 60)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(lineWidth: 3)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .offset(x: selectedAuth == 0 ? 0 : UIScreen.main.bounds.width * 0.3)
                        .animation(.spring(response: 0.35, dampingFraction: 0.7, blendDuration: 0), value: selectedAuth)
                    
                    HStack (spacing: 0) {
                        ForEach(0..<title.count, id: \.self) {index in
                            Button {
                                withAnimation (.spring) {
                                    selectedAuth = index
                                }
                            } label: {
                                Text(title[index])
                                    .foregroundStyle(selectedAuth == index ? .white : Color(.systemGray3))
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.3, alignment: .center)
                        }
                    }
                    .font(.headline)
                }
                .frame(width: UIScreen.main.bounds.width * 0.6, height: 60)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, UIScreen.main.bounds.width * 0.2)
                
                if selectedAuth == 0 {
                    LoginView()
                } else {
                    SignUpView()
                }
            }
            .padding(.top, 30)
        }
    }
}

#Preview {
    AuthView(coin: sampleCoinData)
        .environmentObject(AuthViewModel())
        .environmentObject(CryptoViewModel())
}
