//
//  pocketWordsTests.swift
//  pocketWordsTests
//
//  Created by Mohammad on 5/12/25.
//

import XCTest
@testable import pocketWords

final class pocketWordsTests: XCTestCase {
    
    // MARK: - Properties
    
    var viewModel: FlashcardViewModel!
    
    // MARK: - Init
    
    override func setUp() {
        super.setUp()
        viewModel = FlashcardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - ViewModels
    
    func testExactMatch_ReturnsTrue() {
        let result = viewModel.checkAnswer(userInput: "سیب", correctMeaning: "سیب")
        XCTAssertTrue(result, "Exact matching words should return true.")
    }
    
    func testAnswerWithExtraSpaces_ReturnsTrue() {
        let result = viewModel.checkAnswer(userInput: "  سیب  ", correctMeaning: "سیب")
        XCTAssertTrue(result, "Input with leading/trailing spaces should be trimmed and accepted.")
    }
    
    func testCaseInsensitiveAnswer_ReturnsTrue() {
        let result = viewModel.checkAnswer(userInput: "سیب", correctMeaning: "سیب".uppercased())
        XCTAssertTrue(result, "Input with different cases should be considered correct.")
    }
    
    func testIncorrectAnswer_ReturnsFalse() {
        let result = viewModel.checkAnswer(userInput: "ماشین", correctMeaning: "سیب")
        XCTAssertFalse(result, "Incorrect answer should return false.")
    }
    
    func testEmptyAnswer_ReturnsFalse() {
        let result = viewModel.checkAnswer(userInput: "", correctMeaning: "سیب")
        XCTAssertFalse(result, "Empty input should return false.")
    }
    
    func testOnlyWhitespaceInput_ReturnsFalse() {
        let result = viewModel.checkAnswer(userInput: "     ", correctMeaning: "سیب")
        XCTAssertFalse(result, "Whitespace-only input should return false.")
    }
    
    func testWhitespaceInBothSides_ReturnsTrue() {
        let result = viewModel.checkAnswer(userInput: "  سیب  ", correctMeaning: "  سیب ")
        XCTAssertTrue(result, "Trimming should be applied to both input and correct answer.")
    }
    
    // MARK: - AnswerChecker
    func testCorrectAnswer() {
        XCTAssertTrue(AnswerChecker.isCorrect(userInput: " Hello ", correctAnswer: "hello"))
    }
    
    func testIncorrectAnswer() {
        XCTAssertFalse(AnswerChecker.isCorrect(userInput: "Hi", correctAnswer: "hello"))
    }
    
}
