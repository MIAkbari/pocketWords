//
//  FlashcardViewModel.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import Foundation
import SwiftData
import SwiftUI

@Observable
class FlashcardViewModel {
    var xp: Int = 0
    var currentIndex: Int = 0
    var wordCards: [WordCard] = []
    
    func checkAnswer(userInput: String, correctMeaning: String) -> Bool {
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedAnswer = correctMeaning.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return trimmedInput == trimmedAnswer
    }
    
    func addXP() {
        xp += 10
    }

    var progress: Double {
        guard !wordCards.isEmpty else { return 0.0 }
        let total = Double(wordCards.count)
        let correct = Double(xp / 10)
        return correct / total
    }
}
