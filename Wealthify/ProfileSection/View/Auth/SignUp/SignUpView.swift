//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var email: String = ""
    @State var phone: String = ""
    @State var fullName: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var showPassword: Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack (spacing: 50) {
            
            VStack (alignment: .trailing, spacing: 18) {
                CredentialElementView(title: "Email", fieldTitle: "user@example.com", value: $email)
                    .autocapitalization(.none)
                CredentialElementView(title: "Contact Number", fieldTitle: "9999999999", value: $phone)
                CredentialElementView(title: "Full Name", fieldTitle: "User", value: $fullName)
                    .autocapitalization(.none)
                
                ZStack (alignment: .trailing) {
                    if showPassword {
                        CredentialElementView(title: "Password", fieldTitle: "\(password)", value: $password)
                            .autocapitalization(.none)
                    } else {
                        PasswordView(title: "Password", fieldTitle: "8-12 characters", value: $password)
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
                
                ZStack (alignment: .trailing) {
                    PasswordView(title: "Confirm Password", fieldTitle: "8-12 characters", value: $confirmPassword)
                        .autocapitalization(.none)
                    
                    Image(systemName: !password.isEmpty ? (password == confirmPassword ?  "checkmark.circle.fill" : "xmark.circle.fill") : "")
                        .frame(width: 36)
                        .padding(.horizontal, 12)
                        .padding(.top, 26)
                        .foregroundStyle(password == confirmPassword ? .green : .red)
                }
            }
            .padding(.horizontal)
            .frame(height: 425)
            
            Button {
                Task {
                    do {
                        try await authViewModel.createUser(email: email, password: password, fullName: fullName, phone: phone)
                    } catch {
                        alertMessage = error.localizedDescription
                        showAlert.toggle()
                    }
                }
            } label: {
                Text("Sign Up")
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
    SignUpView()
}
