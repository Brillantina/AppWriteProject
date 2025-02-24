//
//  NoteService.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import Foundation
import Appwrite
import JSONCodable

class NoteService: ObservableObject {
    
    static let shared = NoteService()
    
    let databases: Databases
    let storage: Storage
    
    let databaseId = "67abb2e9003074660ba7"
    let collectionId = "67abb2f40034b82b0698"
    
    @Published private(set) var notes: [Note] = []
    
    init() {
        let client = AppwriteService.shared.client
        self.databases = Databases(client)
        self.storage = Storage(client)
    }
    
    /// **Aggiunge una nuova nota**
    func addNote(text: String) async throws {
        
        //        let noteData: [String: AnyCodable] = [
        //            "text": AnyCodable(text)
        //        ]
        do {
            _ = try await databases.createDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: ID.unique(),
                data:["text": text]
            )
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateNote(id: String, newText: String) async {
        do {
            _ = try await databases.updateDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: id,
                data: ["text": newText]
            )
            await fetchNotes()
        } catch {
            print("Error updating note: \(error.localizedDescription)")
        }
    }
    
    func deleteNote(id: String) async {
        do {
            _ = try await databases.deleteDocument(
                databaseId: databaseId,
                collectionId: collectionId,
                documentId: id
            )
            await fetchNotes()
        } catch {
            print("Error deleting note: \(error.localizedDescription)")
        }
    }
    
    /// **Recupera le note**
    func fetchNotes() async {
        do {
            let response = try await databases.listDocuments(
                databaseId: databaseId,
                collectionId: collectionId
            )
            
            self.notes = response.documents.compactMap { document in
                if let text = document.data["text"]?.value as? String {
                    return Note(id: document.id, text: text)
                }
                return nil
            }
        } catch {
            print("Error fetching notes: \(error.localizedDescription)")
            self.notes = []
        }
    }
}
