import SwiftUI
import SwiftData
import OSLog

class AddCardViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var word = ""
    @Published var meaning = ""
    
    // MARK: - Private Properties
    private var modelContext: ModelContext?
    
    // MARK: - Public Methods
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveCard() {
        guard !word.isEmpty, !meaning.isEmpty else { return }
        
        let card = WordCard(word: word, meaning: meaning)
        modelContext?.insert(card)
        
        do {
            try modelContext?.save()
            Logger.os.debug("✅ Card saved: \(word)")
        } catch {
            Logger.os.debug("❌ Error saving card: \(error.localizedDescription)")
        }
    }
}