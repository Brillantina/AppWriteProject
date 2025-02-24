//
//  AuthView.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(isSignUp ? "Registrati" : "Accedi")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 5)
                }
                
                if isLoading {
                    ProgressView()
                        .padding()
                }
                
                Button(action: {
                    isLoading = true
                    if isSignUp {
                        viewModel.signUp(email: email, password: password) {
                            isLoading = false
                        }
                    } else {
                        viewModel.signIn(email: email, password: password) {
                            isLoading = false
                        }
                    }
                }) {
                    Text(isSignUp ? "Registrati" : "Accedi")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(email.isEmpty || password.isEmpty || isLoading)
                
                Button(action: {
                    isSignUp.toggle()
                }) {
                    Text(isSignUp ? "Hai già un account? Accedi" : "Non hai un account? Registrati")
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
            .navigationDestination(isPresented: Binding(
                get: { viewModel.user != nil },
                set: { _ in }
            )) {
                HomeView(isAuthenticated: $isSignUp)
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel()) 
}
