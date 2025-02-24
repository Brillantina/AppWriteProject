//
//  appwriteProjectApp.swift
//  appwriteProject
//
//  Created by Rita Marrano on 10/02/25.
//

import SwiftUI
import SwiftData
import Appwrite

@main
struct FirebaseProjectApp: App {
    
  @StateObject private var authViewModel = AuthViewModel()
    
  var body: some Scene {
    WindowGroup {
      NavigationView {
          AuthView()
              .environmentObject(authViewModel)
      }
    }
  }
}

