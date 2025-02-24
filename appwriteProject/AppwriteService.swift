//
//  AuthViewModel.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import Foundation
import Appwrite
import JSONCodable

class AppwriteService {
    static let shared = AppwriteService()
    let client: Client
    let account: Account

    private init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("67aa84a7002b17ea256c") // Sostituisci con il tuo Project ID

        self.account = Account(client)
    }

    func register(email: String, password: String) async throws -> User<[String: AnyCodable]> {
        print("[AppwriteService] Tentativo di registrazione con email: \(email)")
        return try await account.create(
            userId: ID.unique(),
            email: email,
            password: password
        )
    }

    func login(email: String, password: String) async throws -> Session {
        print("[AppwriteService] Tentativo di login con email: \(email)")
        return try await account.createEmailPasswordSession(
            email: email,
            password: password
        )
    }

    func logout() async throws {
        print("[AppwriteService] Tentativo di logout")
        try await account.deleteSession(sessionId: "current")
    }
}
