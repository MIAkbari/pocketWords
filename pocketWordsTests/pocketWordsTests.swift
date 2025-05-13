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
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        viewModel = FlashcardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - ViewModel Tests
    
    func testExactMatch_ReturnsTrue() {
        XCTAssertTrue(viewModel.checkAnswer(userInput: "Apple", correctMeaning: "Apple"))
    }
    
    func testAnswerWithExtraSpaces_ReturnsTrue() {
        XCTAssertTrue(viewModel.checkAnswer(userInput: "  Apple  ", correctMeaning: "Apple"))
    }
    
    func testCaseInsensitiveAnswer_ReturnsTrue() {
        XCTAssertTrue(viewModel.checkAnswer(userInput: "Apple", correctMeaning: "Apple".uppercased()))
    }
    
    func testIncorrectAnswer_ReturnsFalse() {
        XCTAssertFalse(viewModel.checkAnswer(userInput: "Car", correctMeaning: "Apple"))
    }
    
    func testEmptyAnswer_ReturnsFalse() {
        XCTAssertFalse(viewModel.checkAnswer(userInput: "", correctMeaning: "Apple"))
    }
    
    func testOnlyWhitespaceInput_ReturnsFalse() {
        XCTAssertFalse(viewModel.checkAnswer(userInput: "     ", correctMeaning: "Apple"))
    }
    
    func testWhitespaceInBothSides_ReturnsTrue() {
        XCTAssertTrue(viewModel.checkAnswer(userInput: "  Apple  ", correctMeaning: "  Apple "))
    }
}
