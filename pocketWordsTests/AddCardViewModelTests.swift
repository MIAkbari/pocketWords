import XCTest
import SwiftData
@testable import YourAppName // نام پروژه خود را جایگزین کنید

final class AddCardViewModelTests: XCTestCase {
    var viewModel: AddCardViewModel!
    var modelContext: ModelContext!
    var container: ModelContainer!
    
    override func setUp() {
        super.setUp()
        // تنظیم مدل و استفاده از حافظه موقت
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
    
    // MARK: - تست‌های Validation
    func testSaveButtonDisabledWhenFieldsEmpty() {
        viewModel.word = ""
        viewModel.meaning = ""
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = "Hello"
        viewModel.meaning = ""
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = ""
        viewModel.meaning = "سلام"
        XCTAssertTrue(viewModel.isSaveDisabled)
        
        viewModel.word = "Hello"
        viewModel.meaning = "سلام"
        XCTAssertFalse(viewModel.isSaveDisabled)
    }
    
    // MARK: - تست‌های Saving
    func testSaveCardInsertsIntoContext() {
        viewModel.word = "Book"
        viewModel.meaning = "کتاب"
        
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