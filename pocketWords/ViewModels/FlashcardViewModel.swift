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
    
    // MARK: - Properties
    
    var xp: Int = 0
    var currentIndex: Int = 0
    var wordCards: [WordCard] = []
    var progress: Double {
        guard !wordCards.isEmpty else { return 0.0 }
        let total = Double(wordCards.count)
        let correct = Double(xp / 10)
        return correct / total
    }
    
    // MARK: - Func
    
    func checkAnswer(userInput: String, correctMeaning: String) -> Bool {
        return AnswerChecker.isCorrect(userInput: userInput, correctAnswer: correctMeaning)
    }
    
    func addXP() {
        xp += 10
    }
}
