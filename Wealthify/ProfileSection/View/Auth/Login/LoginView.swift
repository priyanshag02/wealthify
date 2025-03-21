//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var email: String = ""
    @State var password: String = ""
    @State var showPassword: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State var showAlert = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack (spacing: 50) {
            
            VStack (alignment: .trailing, spacing: 18) {
                CredentialElementView(title: "Email", fieldTitle: "user@example.com", value: $email)
                    .autocapitalization(.none)
                
                ZStack (alignment: .trailing) {
                    if showPassword {
                        CredentialElementView(title: "New Password", fieldTitle: "\(password)", value: $password)
                            .autocapitalization(.none)
                    } else {
                        PasswordView(title: "New Password", fieldTitle: "8-12 characters", value: $password)
                            .autocapitalization(.none)
                    }
                    Button {
                        showPassword.toggle()
                    } label: {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .frame(width: 36)
                            .padding(.horizontal, 12)
                            .padding(.top, 26)
                            .modifier(colorModifier())
                    }
                }
                
                Button {
                    Task {
                        do {
                            try await authViewModel.resetPassword(withEmail: email)
                            alertMessage = "A password reset email has been sent to \(email). Please check your inbox."
                        } catch {
                            alertMessage = error.localizedDescription
                            showAlert.toggle()
                        }
                    }
                } label: {
                    Text("Forgot Password")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .frame(height: 425)
            
            Button {
                Task {
                    do {
                        try await authViewModel.signIn(email: email, password: password)
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert.toggle()
                    }
                }
            } label: {
                Text("Log in")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 100, height: 50)
                    .background(.blue.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 16))
            }
            Spacer()
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Ok"))
            )
        }
        .padding(.vertical, 30)
    }
}

#Preview {
    LoginView()
}
