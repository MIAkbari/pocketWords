//
//  ContentView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//

import SwiftUI
import SwiftData

struct FlashcardView: View {
    
    // MARK: - Environment & Query
    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [WordCard]
    @Query private var progressList: [UserProgress]
    
    // MARK: - ViewModel
    @StateObject private var viewModel = FlashcardViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            if cards.isEmpty {
                emptyStateView
            } else {
                flashCardView
                inputField
                progressView
                navigationButtons
            }
        }
        .padding()
        .navigationTitle("PocketWords")
        .toolbar { addCardButton }
        .onAppear { viewModel.setup(cards: cards, progressList: progressList, modelContext: modelContext) }
        .onChange(of: cards) { viewModel.setup(cards: $0, progressList: progressList, modelContext: modelContext) }
        .onChange(of: progressList) { viewModel.setup(cards: cards, progressList: $0, modelContext: modelContext) }
    }
    
    // MARK: - Subviews
    private var emptyStateView: some View {
        Text("No cards yet. Add some!")
            .foregroundColor(.gray)
    }
    
    private var flashCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(height: 200)
                .overlay(cardContent)
                .rotation3DEffect(.degrees(viewModel.flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture { flipCard() }
        }
    }
    
    private var cardContent: some View {
        Group {
            if let card = currentCard {
                Text(viewModel.flipped ? card.meaning : card.word)
                    .font(.title)
                    .foregroundColor(.white)
                    .accessibilityLabel(viewModel.flipped ? card.meaning : card.word)
                    .accessibilityHint("Double tap to flip the card.")
            }
        }
    }
    
    private var inputField: some View {
        TextField("Enter meaning", text: $viewModel.userInput)
            .textFieldStyle(.roundedBorder)
            .border(viewModel.feedbackColor ?? .clear, width: 2)
            .padding(.horizontal)
            .onSubmit { viewModel.checkAnswer() }
            .accessibilityLabel("Meaning input field")
            .accessibilityHint("Type your guess and press return.")
    }
    
    private var progressView: some View {
        VStack(spacing: 8) {
            ProgressView(
                value: Double(progressValue),
                total: Double(max(1, cards.count * 10))
            )
            .progressViewStyle(.linear)
            .tint(.green)
            .frame(height: 10)
            
            Text("XP: \(progressValue) / \(max(1, cards.count * 10))")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var navigationButtons: some View {
        HStack {
            Button("Previous") { viewModel.moveToPrevious() }
            Spacer()
            Button("Next") { viewModel.moveToNext() }
        }
        .padding(.horizontal)
    }
    
    private var addCardButton: some View {
        NavigationLink {
            AddCardView()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    // MARK: - Helper Properties
    private var currentCard: WordCard? {
        guard !cards.isEmpty,
              viewModel.currentIndex >= 0,
              viewModel.currentIndex < cards.count
        else { return nil }
        
        return cards[viewModel.currentIndex]
    }
    
    private var progressValue: Int {
        viewModel.progress?.xp ?? 0
    }
    
    // MARK: - Methods
    private func flipCard() {
        withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.flipped.toggle()
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        FlashcardView()
    }
}
