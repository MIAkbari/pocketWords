//
//  FlashcardView 2.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import SwiftUI

struct FlashcardView_Preview: View {
    var cards: [WordCard]

    @State private var index = 0
    @State private var flipped = false
    @State private var xp = 10

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue)
                    .frame(height: 200)
                    .overlay(
                        Text(flipped ? cards[index].meaning : cards[index].word)
                            .foregroundColor(.white)
                            .font(.title)
                    )
            }

            ProgressView(value: Double(xp), total: Double(cards.count * 10))
                .progressViewStyle(.linear)
                .padding()
        }
        .padding()
    }
}

#Preview {
    FlashcardView_Preview(cards: [WordCard(word: "Tree", meaning: "درخت")])
}
