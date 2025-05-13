//
//  AddCardView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//



import SwiftUI
import SwiftData
import OSLog

struct AddCardView: View {
    
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var word = ""
    @State private var meaning = ""
    
    // MARK: - Body . Init
    
    var body: some View {
        mainView
    }
    
    // MARK: - Views
    
    private var mainView: some View {
        NavigationStack {
            formView
                .navigationTitle("New Word")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        saveButtonView
                    }
                }
        }
    }
    
    private var formView: some View {
        Form {
            TextField("Word", text: $word)
                .accessibilityLabel("TextField Save Word")
                .accessibilityHint("Input to save the new word card")
            
            TextField("Meaning", text: $meaning)
                .accessibilityLabel("TextField Save Meaning")
                .accessibilityHint("Input to save the new Meaning card")
        }
    }
    
    private var saveButtonView: some View {
        Button("Save") {
            saveCard()
            dismiss()

        }
        .disabled(word.isEmpty || meaning.isEmpty)
        .accessibilityLabel("Save Word")
        .accessibilityHint("Tap to save the new word card")

    }
    
    // MARK: - Func
    
    private func saveCard() {
        let card = WordCard(word: word, meaning: meaning)
        modelContext.insert(card)
        do {
            try modelContext.save()
        } catch {
            Logger.os.debug("❌ Error saving: \(error.localizedDescription)")
        }
    }
}

// MARK: - Preview

#Preview {
    AddCardView()
}
