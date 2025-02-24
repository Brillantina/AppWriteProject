//
//  HomeView.swift
//  appwriteProject
//
//  Created by Rita Marrano on 11/02/25.
//

import SwiftUI
import Appwrite

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isAuthenticated: Bool
    @StateObject private var noteService = NoteService.shared
    @State private var newNoteText = ""
    @State private var selectedNote: Note?
    @State private var showingNoteSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(authViewModel.user?.email ?? "Utente")!")
                .font(.title)
                .fontWeight(.semibold)
                .padding()
            
            Button(action: {
                authViewModel.signOut()
                isAuthenticated = false
            }) {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        VStack {
            Text("Note")
                .font(.title)
                .padding()
            
            List {
                ForEach(noteService.notes) { note in
                    Button(action: {
                        selectedNote = note
                        showingNoteSheet = true
                    }) {
                        HStack {
                            Text(note.text)
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .foregroundColor(.primary)
                }
            }
            
            Divider()
            
            TextField("Aggiungi una nota...", text: $newNoteText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Salva Nota") {
                Task {
                    try await NoteService().addNote(text: newNoteText)
                    newNoteText = ""
                }
            }
            .disabled(newNoteText.isEmpty)
            .buttonStyle(.borderedProminent)
            .padding()
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await noteService.fetchNotes()
            }
        }
        .sheet(isPresented: $showingNoteSheet) {
            if let note = selectedNote {
                NoteDetailView(note: note)
            }
        }
    }
}

#Preview {
    HomeView(isAuthenticated: .constant(true))
        .environmentObject(AuthViewModel()) 
}
