//
//  AmountView.swift
//  Money
//
//  Created by Priyansh on 23/02/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isLoading: Bool = true
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
            self.isLoading = false
        }
    }
    
    enum AuthError: LocalizedError {
        case invalidCredentials
        case userNotFound
        case passwordResetFailed
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Invalid email and password"
            case .userNotFound:
                return "User with email cannot be found"
            case .passwordResetFailed:
                return "Password reset mail cannot be sent"
            case .unknownError:
                return "An unknown error occured"
            }
        }
    }
    
    func createUser (email: String, password: String, fullName: String, phone: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullName, email: email, phone: phone)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("user").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func signIn (email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch let error as NSError {
            if error.code == AuthErrorCode.userNotFound.rawValue {
                throw AuthError.userNotFound
            } else if error.code == AuthErrorCode.wrongPassword.rawValue {
                throw AuthError.invalidCredentials
            } else {
                throw error
            }
        }
    }
    
    func signOut()  {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            self.userSession = nil
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(password: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        let credentials = EmailAuthProvider.credential(withEmail: user.email!, password: password)
        do {
            try await user.reauthenticate(with: credentials)
            try await user.delete()
            try await Firestore.firestore().collection("user").document(user.uid).delete()
            self.signOut()
        } catch {
            print("DEBUG: Failed to delete account: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let id = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("user").document(id).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func resetPassword(withEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.passwordResetFailed
        }
    }
    
    func changePassword(newPassword: String, currentPassword: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        let credentials = EmailAuthProvider.credential(withEmail: user.email!, password: currentPassword)
        do {
            try await user.reauthenticate(with: credentials)
            try await user.updatePassword(to: newPassword)
        } catch {
            if let authError = error as? NSError, authError.code == AuthErrorCode.wrongPassword.rawValue {
                throw AuthError.invalidCredentials
            } else {
                throw AuthError.unknownError
            }
        }
    }
}

protocol AuthFormProtocol {
    var isFormValid: Bool { get }
}
