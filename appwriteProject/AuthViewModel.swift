//
//  AuthView.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import Foundation
@preconcurrency import Appwrite
import JSONCodable

class AuthViewModel: ObservableObject {
    @Published var user: User<[String: AnyCodable]>? = nil
    @Published var errorMessage: String? = nil

    init() {
        Task {
            await fetchUser()
        }
    }

    func fetchUser() async {
        do {
            let fetchedUser = try await AppwriteService.shared.account.get()
            DispatchQueue.main.async { [self] in
                user = fetchedUser
                errorMessage = nil
                print("[AuthViewModel] Utente autenticato: \(fetchedUser.email ?? "N/A")")
            }
        } catch let error as AppwriteError {
            DispatchQueue.main.async {
                self.user = nil
                self.errorMessage = "Errore nel recupero utente: \(error.message ?? "Errore sconosciuto")"
                print("[AuthViewModel] Nessun utente autenticato o errore nel recupero: \(error.message ?? "Errore sconosciuto")")
            }
        } catch {
            DispatchQueue.main.async {
                self.user = nil
                self.errorMessage = error.localizedDescription
                print("[AuthViewModel] Errore generico: \(error.localizedDescription)")
            }
        }
    }


    /// Login con closure di completamento
    func signIn(email: String, password: String, completion: (() -> Void)? = nil) {
        Task {
            do {
                _ = try await AppwriteService.shared.login(email: email, password: password)
                await fetchUser()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("[AuthViewModel] Errore di login: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion?()  // Esegue il completamento dopo l'operazione
            }
        }
    }

    /// Registrazione con closure di completamento
    func signUp(email: String, password: String, completion: (() -> Void)? = nil) {
        Task {
            do {
                _ = try await AppwriteService.shared.register(email: email, password: password)
                _ = try await AppwriteService.shared.login(email: email, password: password)
                await fetchUser()
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("[AuthViewModel] Errore di registrazione: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion?()  // Esegue il completamento dopo l'operazione
            }
        }
    }

    func signOut(completion: (() -> Void)? = nil) {
        Task {
            do {
                try await AppwriteService.shared.logout()
                DispatchQueue.main.async {
                    self.user = nil
                    print("[AuthViewModel] Logout effettuato con successo.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    print("[AuthViewModel] Errore durante il logout: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
}
