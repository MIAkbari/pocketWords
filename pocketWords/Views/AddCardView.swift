//
//  AddCardView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//



import SwiftUI
import SwiftData

struct AddCardView: View {
    // MARK: - Environment & Properties
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - ViewModel
    @StateObject private var viewModel = AddCardViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            formView
                .navigationTitle("New Word")
                .toolbar { saveButtonToolbarItem }
        }
        .onAppear { viewModel.setup(modelContext: modelContext) }
    }
    
    // MARK: - Subviews
    private var formView: some View {
        Form {
            TextField("Word", text: $viewModel.word)
                .accessibilityLabel("TextField Save Word")
            
            TextField("Meaning", text: $viewModel.meaning)
                .accessibilityLabel("TextField Save Meaning")
        }
    }
    
    private var saveButtonToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
                viewModel.saveCard()
                dismiss()
            }
            .disabled(viewModel.isSaveDisabled)
            .accessibilityLabel("Save Word")
        }
    }
}

// MARK: - Preview

#Preview {
    AddCardView()
}
