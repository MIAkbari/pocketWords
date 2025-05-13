//
//  FlashcardViewModel.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import SwiftUI
import SwiftData
import OSLog

class FlashcardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var flipped = false
    @Published var currentIndex = 0
    @Published var userInput = ""
    @Published var feedbackColor: Color? = nil
    @Published var progress: UserProgress?
    
    // MARK: - Private Properties
    private var modelContext: ModelContext?
    private var cards: [WordCard] = [] {
        didSet {
            let validIndexRange = cards.isEmpty ? 0...0 : 0...(max(cards.count - 1, 0))
            currentIndex = min(max(currentIndex, validIndexRange.lowerBound), validIndexRange.upperBound)
        }
    }
    
    // MARK: - Public Methods
    func setup(cards: [WordCard], progressList: [UserProgress], modelContext: ModelContext) {
        self.cards = cards
        self.modelContext = modelContext
        updateProgress(progressList)
    }
    
    func checkAnswer() {
        guard let progress = progress, currentIndex < cards.count else { return }
        let card = cards[currentIndex]
        
        let correct = card.meaning
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let input = userInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        if input == correct {
            feedbackColor = .green
            progress.xp = min(progress.xp + 10, cards.count * 10)
        } else {
            feedbackColor = .red
        }
        
        saveContext()
    }
    
    func reset() {
        userInput = ""
        feedbackColor = nil
        flipped = false
    }
    
    func moveToNext() {
        guard !cards.isEmpty else { return }
        currentIndex = min(currentIndex + 1, cards.count - 1)
    }

    func moveToPrevious() {
        guard !cards.isEmpty else { return }
        currentIndex = max(currentIndex - 1, 0)
    }
    
    // MARK: - Private Methods
    private func updateProgress(_ progressList: [UserProgress]) {
        if let existing = progressList.first {
            progress = existing
        } else {
            let newProgress = UserProgress()
            modelContext?.insert(newProgress)
            progress = newProgress
        }
    }
    
    private func saveContext() {
        do {
            try modelContext?.save()
        } catch {
            Logger.os.debug("Error saving progress: \(error.localizedDescription)")
        }
    }
}
