//
//  AnswerChecker.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import Foundation

// MARK: - For Test
enum AnswerChecker {
    static func isCorrect(userInput: String, correctAnswer: String) -> Bool {
        userInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased() ==
        correctAnswer
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
}
