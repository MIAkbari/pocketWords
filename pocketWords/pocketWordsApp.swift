//
//  pocketWordsApp.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//

import SwiftUI

@main
struct pocketWordsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                FlashcardView()
            }
            .modelContainer(for: [WordCard.self, UserProgress.self]) // if lat model use Schema.allModels
        }
    }
}
