//
//  WordCard.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import Foundation
import SwiftData

@Model
class WordCard {
    var word: String
    var meaning: String
    var createdAt: Date

    init(word: String, meaning: String) {
        self.word = word
        self.meaning = meaning
        self.createdAt = Date()
    }
}
