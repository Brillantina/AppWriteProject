//
//  NoteItemView.swift
//  appwriteProject
//
//  Created by Rita Marrano on 12/02/25.
//

import SwiftUI

struct NoteItemView: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(note.text)
                    .font(.headline)
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .contentShape(Rectangle())  // Makes the entire row tappable
        .onTapGesture {
            onTap()
        }
    }
}
