//
//  SwiftUIView.swift
//  Wealthify
//
//  Created by Priyansh on 12/03/25.
//

import SwiftUI

struct DeleteAccountSheet: View {
    @Environment(\.dismiss) var dismiss
        @EnvironmentObject var authViewModel: AuthViewModel
        @Binding var isShowing: Bool
        @State private var password: String = ""
        @State private var isLoading: Bool = false
        @State private var confirmationStep: Bool = false
        @Binding var errorMessage: String
        @Binding var showError: Bool
        @State private var localErrorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Delete Account")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("This action cannot be undone. Please enter your password to confirm.")
                .font(.subheadline)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
            
            HStack(spacing: 0) {
                Button("Cancel") {
                    isShowing = false
                }
                .frame(width: 125)
                
                Button {
                    deleteAccount()
                } label: {
                    if isLoading {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Text("Delete")
                    }
                }
                .frame(width: 125)
                .tint(.red)
                .disabled(password.isEmpty || isLoading )
            }
            .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.30)
        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
        .cornerRadius(12)
        .shadow(radius: 10)
        .alert (isPresented: $showError) {
            Alert (title: Text("Error"), message: Text("\(errorMessage)"), dismissButton: .default(Text("Ok")))
        }
    }
    
    private func deleteAccount() {
            isLoading = true
            Task {
                do {
                    try await authViewModel.deleteAccount(password: password)
                    isShowing = false
                } catch {
                    errorMessage = error.localizedDescription
                    showError = true
                    isLoading = false
                }
            }
        }
}

#Preview {
    DeleteAccountSheet(isShowing: .constant(false), errorMessage: .constant("false"), showError: .constant(false))
        .environmentObject(AuthViewModel())
}
