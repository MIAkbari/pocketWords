//
//  AddCardView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//



import SwiftUI
import SwiftData

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var word = ""
    @State private var meaning = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Word", text: $word)
                TextField("Meaning", text: $meaning)
            }
            .navigationTitle("New Word")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newCard = WordCard(word: word, meaning: meaning)
                        modelContext.insert(newCard)
                        dismiss()
                    }
                    .disabled(word.isEmpty || meaning.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    AddCardView()
}
