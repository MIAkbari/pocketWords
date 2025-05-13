//
//  FullFlowPreview.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//


import SwiftUI

struct FullFlowPreview: View {
    @State private var cards = [
        WordCard(word: "Tree", meaning: "درخت"),
        WordCard(word: "Apple", meaning: "سیب")
    ]
    
    @State private var currentIndex = 0
    @State private var flipped = false
    @State private var userInput = ""
    @State private var xp = 0
    @State private var showFeedback: Bool? = nil

    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.indigo)
                    .frame(height: 200)
                    .overlay(
                        Text(flipped ? cards[currentIndex].meaning : cards[currentIndex].word)
                            .font(.title)
                            .foregroundColor(.white)
                            .rotation3DEffect(
                                .degrees(flipped ? 180 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .accessibilityLabel(flipped ? "Meaning: \(cards[currentIndex].meaning)" : "Word: \(cards[currentIndex].word)")
                            .accessibilityHint("Tap to flip the card")
                    )
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.4)) {
                    flipped.toggle()
                }
            }

            TextField("Type the meaning", text: $userInput, onCommit: {
                if AnswerChecker.isCorrect(userInput: userInput, correctAnswer: cards[currentIndex].meaning) {
                    xp += 10
                    showFeedback = true
                } else {
                    showFeedback = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showFeedback = nil
                    userInput = ""
                    if currentIndex < cards.count - 1 {
                        currentIndex += 1
                        flipped = false
                    }
                }
            })
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            .accessibilityLabel("Meaning input field")
            .accessibilityHint("Type your guess and press return.")

            if let correct = showFeedback {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(correct ? .green : .red)
                    .transition(.scale)
            }

            ProgressView(value: Double(xp), total: Double(cards.count * 10))
                .padding()
                .accessibilityLabel("Progress")
                .accessibilityValue("\(xp) out of \(cards.count * 10) XP")
        }
        .padding()
    }
}

#Preview {
    FullFlowPreview()
}
