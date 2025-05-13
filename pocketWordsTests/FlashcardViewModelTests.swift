//
//  pocketWordsTests.swift
//  pocketWordsTests
//
//  Created by Mohammad on 5/12/25.
//

import XCTest
import SwiftData
@testable import pocketWords

final class FlashcardViewModelTests: XCTestCase {
    var viewModel: FlashcardViewModel!
    var modelContext: ModelContext!
    var container: ModelContainer!
    
    override func setUp() {
        super.setUp()
        
        let schema = Schema([WordCard.self, UserProgress.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: config)
        modelContext = ModelContext(container)
        
        viewModel = FlashcardViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        modelContext = nil
        container = nil
        super.tearDown()
    }
    
    // MARK: -  Initial Setup
    func testInitialStateWithEmptyCards() {
        viewModel.setup(cards: [], progressList: [], modelContext: modelContext)
        
        XCTAssertEqual(viewModel.currentIndex, 0)
        XCTAssertEqual(viewModel.progress?.xp, 0)
    }
    
    // MARK: -  Navigation
    func testMoveToNextCard() {
        let cards = [
            WordCard(word: "Hello", meaning: "Hello"),
            WordCard(word: "Goodbye", meaning: "Goodbye")
        ]
        viewModel.setup(cards: cards, progressList: [], modelContext: modelContext)
        
        viewModel.moveToNext()
        XCTAssertEqual(viewModel.currentIndex, 1)
        
        viewModel.moveToNext()
        XCTAssertEqual(viewModel.currentIndex, 1)
    }
    
    func testMoveToPreviousCard() {
        let cards = [
            WordCard(word: "Hello", meaning: "Hello"),
            WordCard(word: "Goodbye", meaning: "Goodbye")
        ]
        viewModel.setup(cards: cards, progressList: [], modelContext: modelContext)
        viewModel.currentIndex = 1
        
        viewModel.moveToPrevious()
        XCTAssertEqual(viewModel.currentIndex, 0)
        
        viewModel.moveToPrevious()
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
    
    // MARK: - Answer Checking
    func testCorrectAnswerUpdatesXP() {
        let cards = [WordCard(word: "Apple", meaning: "Apple")]
        viewModel.setup(cards: cards, progressList: [], modelContext: modelContext)
        viewModel.userInput = "Apple"
        
        viewModel.checkAnswer()
        
        XCTAssertEqual(viewModel.feedbackColor, .green)
        XCTAssertEqual(viewModel.progress?.xp, 10)
    }
    
    func testIncorrectAnswerDoesNotUpdateXP() {
        let cards = [WordCard(word: "Apple", meaning: "Apple")]
        viewModel.setup(cards: cards, progressList: [], modelContext: modelContext)
        viewModel.userInput = "wrong"
        
        viewModel.checkAnswer()
        
        XCTAssertEqual(viewModel.feedbackColor, .red)
        XCTAssertEqual(viewModel.progress?.xp, 0)
    }
    
    // MARK: - Edge Cases
    func testEmptyCardsHandling() {
        viewModel.setup(cards: [], progressList: [], modelContext: modelContext)
        
        viewModel.moveToNext()
        viewModel.moveToPrevious()
        
        XCTAssertEqual(viewModel.currentIndex, 0)
    }
}
