//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI

struct PasswordChangeView: View {
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    @State var currentPassword: String = ""
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var showPassword: Bool = false
    @ObservedObject var authViewModel: AuthViewModel
    @State var showPasswordAlert: Bool = false
    @State var showSuccessAlert: Bool = false
    var successMessage: String = "Password changed successfully"
    var alertMessage: String = ""
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 30) {
                PasswordView(title: "Current Password", fieldTitle: "8-12 characters", value: $currentPassword)
                ZStack (alignment: .trailing) {
                    if showPassword {
                        CredentialElementView(title: "New Password", fieldTitle: "\(newPassword)", value: $newPassword)
                    } else {
                        PasswordView(title: "New Password", fieldTitle: "8-12 characters", value: $newPassword)
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
                    PasswordView(title: "New Password", fieldTitle: "8-12 characters", value: $confirmPassword)
                    
                    Image(systemName: !newPassword.isEmpty ? (newPassword == confirmPassword ?  "checkmark.circle.fill" : "xmark.circle.fill") : "")
                        .frame(width: 36)
                        .padding(.horizontal, 12)
                        .padding(.top, 26)
                        .foregroundStyle(newPassword == confirmPassword ? .green : .red)
                }
                
                Button {
                    Task {
                        do {
                            try await authViewModel.changePassword(newPassword: newPassword, currentPassword: currentPassword)
                            showSuccessAlert.toggle()
                            dismiss()
                        } catch {
                            showPasswordAlert.toggle()
                        }
                    }
                } label: {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 100, height: 50)
                        .background(.blue.opacity(colorScheme == .dark ? 0.4  : 0.9), in: RoundedRectangle(cornerRadius: 16))
                }
                .disabled(!passwordCheck(newPassword: newPassword, confirmPassword: confirmPassword))
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.left")
                                .opacity(0.75)
                            Text("Change Password")
                                .font(.headline)
                        }
                        .modifier(colorModifier())
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .padding(.vertical, 30)
            .padding(.horizontal, 12)
            .alert(isPresented: $showPasswordAlert) {
                Alert(title: Text("Error"),
                      message: Text("\(alertMessage)"),
                      dismissButton: .default(Text("Ok"))
                )
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"),
                      message: Text("\(successMessage)"),
                      dismissButton: .default(Text("Ok"))
                )
            }
            Spacer()
        }
    }
}

#Preview {
    PasswordChangeView(authViewModel: AuthViewModel())
}

extension PasswordChangeView {
    private func passwordCheck(newPassword: String, confirmPassword: String) -> Bool {
        let isLengthValid = newPassword.count >= 8 && newPassword.count <= 12 && confirmPassword.count >= 8 && confirmPassword.count <= 12
        let doPasswordsMatch = newPassword == confirmPassword
        let hasDigit = newPassword.contains { $0.isNumber }
        return isLengthValid && doPasswordsMatch && hasDigit
    }
}
