//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var dob = Date()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    @State private var showPasswordPrompt: Bool = false
    @State private var isDeletingAccount: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 40){
                    VStack (spacing: 20){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Text(authViewModel.currentUser?.fullName ?? "")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    
                    
                }
                VStack (spacing: 18) {
                    DisclosureGroup {
                        HStack {
                            VStack (alignment: .leading ,spacing: 12) {
                                Text("Email: ")
                                    .font(.headline)
                                    .frame(height: 24)
                                Text("Phone: ")
                                    .font(.headline)
                                    .frame(height: 24)
                            }
                            .foregroundStyle(Color(.systemGray))
                            VStack (alignment: .leading ,spacing: 12) {
                                Text(authViewModel.currentUser?.email ?? "")
                                    .font(.subheadline)
                                    .frame(height: 24)
                                    .foregroundStyle(.blue)
                                Text(authViewModel.currentUser?.phone ?? "")
                                    .font(.subheadline)
                                    .frame(height: 24)
                                    .foregroundStyle(.blue)
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } label: {
                        Text("Contact Info")
                            .font(.headline)
                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(colorScheme == .dark ? 0.75 : 1), in: RoundedRectangle(cornerRadius: 16))
                    .modifier(colorModifier())
                    
                    Toggle(isOn: $isDarkMode) {
                        HStack (spacing: 18){
                            Image(systemName: "moon.fill")
                                .resizable()
                                .frame(width: 18, height: 18)
                            Text("Dark Mode")
                                .font(.headline)
                        }
                        .modifier(colorModifier())
                    }
                    .padding(.horizontal, 8)
                    
                    Divider()
                    
                    NavigationLink {
                        PasswordChangeView(authViewModel: authViewModel)
                    } label: {
                        HStack (spacing: 18){
                            Image(systemName: "lock.fill")
                                .resizable()
                                .frame(width: 12, height: 18)
                            Text("Change Password")
                                .font(.headline)
                        }
                    }
                    .modifier(colorModifier())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 8)
                    
                    Divider()
                    
                    NavigationLink {
                        ChangePINView()
                    } label: {
                        HStack (spacing: 18){
                            Image(systemName: "key.fill")
                                .resizable()
                                .frame(width: 12, height: 18)
                            Text("Change PIN")
                                .font(.headline)
                            
                        }
                        .modifier(colorModifier())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                    
                    Divider()
                    
                    Button {
                        showPasswordPrompt = true
                    } label: {
                        HStack (spacing: 14){
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.red)
                            Text("Delete Account")
                                .font(.headline)
                            
                        }
                        .modifier(colorModifier())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                    
                    Divider()
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        HStack (spacing: 18){
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 9, height: 12)
                            Text("Sign Out")
                                .font(.headline)
                        }
                        .modifier(colorModifier())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "arrowshape.left.fill")
                            .opacity(0.75)
                        Text("Profile")
                            .font(.headline)
                    }
                    .modifier(colorModifier())
                }
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden()
        .colorScheme(isDarkMode == true ? .dark : .light)
        .onAppear {
            Task {
                await authViewModel.fetchUser()
            }
        }
        .alert(isPresented: $showPasswordPrompt) {
            Alert(
                title: Text("Confirm Account Deletion"),
                message: Text("Please enter your password to delete the account."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        do {
                            isDeletingAccount = true
                            try await authViewModel.deleteUser(password: password)
                        } catch {
                            alertMessage = error.localizedDescription
                            showAlert = true
                        }
                    }
                },
                secondaryButton: .cancel()
            )
            
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("Ok"))
            )
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
