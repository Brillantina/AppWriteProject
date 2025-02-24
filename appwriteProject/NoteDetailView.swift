//
//  NoteDetailView.swift
//  appwriteProject
//
//  Created by Rita Marrano on 12/02/25.
//
import SwiftUI

struct NoteDetailView: View {
    let note: Note
    @Environment(\.dismiss) var dismiss
    @StateObject private var noteService = NoteService.shared
    @State private var editedText: String
    @State private var showingDeleteAlert = false
    @State private var isEditing = false
    
    init(note: Note) {
        self.note = note
        _editedText = State(initialValue: note.text)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if isEditing {
                TextField("Testo nota", text: $editedText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Annulla") {
                        isEditing = false
                        editedText = note.text
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Salva") {
                        Task {
                            await noteService.updateNote(id: note.id, newText: editedText)
                            isEditing = false
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                Text(note.text)
                    .font(.body)
                    .padding()
                
                HStack {
                    Button("Modifica") {
                        isEditing = true
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Elimina") {
                        showingDeleteAlert = true
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                }
            }
        }
        .padding()
        .navigationTitle("Dettaglio Nota")
        .alert("Conferma eliminazione", isPresented: $showingDeleteAlert) {
            Button("Annulla", role: .cancel) { }
            Button("Elimina", role: .destructive) {
                Task {
                    await noteService.deleteNote(id: note.id)
                    dismiss()
                }
            }
        } message: {
            Text("Sei sicuro di voler eliminare questa nota?")
        }
    }
}
