//
//  AddCardViewModelTests.swift
//  pocketWords
//
//  Created by Mohammad on 5/13/25.
//


import XCTest
import SwiftData
@testable import pocketWords

final class AddCardViewModelTests: XCTestCase {
    
    var viewModel: AddCardViewModel!
    var modelContext: ModelContext!
    var container: ModelContainer!
    
    override func setUp() {
        super.setUp()

        let schema = Schema([WordCard.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: schema, configurations: config)
        modelContext = ModelContext(container)
        
        viewModel = AddCardViewModel()
        viewModel.setup(modelContext: modelContext)
    }
    
    override func tearDown() {
        viewModel = nil
        modelContext = nil
        container = nil
        super.tearDown()
    }
    
    // MARK: -  Validation
    func testSaveButtonDisabledWhenFieldsEmpty() {
        viewModel.word = ""
        viewModel.meaning = ""
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = "Hello"
        viewModel.meaning = ""
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = ""
        viewModel.meaning = "Hello"
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = "Hello"
        viewModel.meaning = "Hello"
        XCTAssertFalse(viewModel.isSaveDisabled)
    }
    
    // MARK: - Saving
    func testSaveCardInsertsIntoContext() {
        viewModel.word = "Book"
        viewModel.meaning = "Book"
        
        viewModel.saveCard()
        
        let fetchDescriptor = FetchDescriptor<WordCard>()
        let cards = try! modelContext.fetch(fetchDescriptor)
        
        XCTAssertEqual(cards.count, 1)
        XCTAssertEqual(cards.first?.word, "Book")
    }
    
    func testSaveEmptyCardDoesNothing() {
        viewModel.word = ""
        viewModel.meaning = ""
        
        viewModel.saveCard()
        
        let fetchDescriptor = FetchDescriptor<WordCard>()
        let cards = try! modelContext.fetch(fetchDescriptor)
        
        XCTAssertEqual(cards.count, 0)
    }
}
