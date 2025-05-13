//
//  ContentView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//

import SwiftUI
import SwiftData
import OSLog

struct FlashcardView: View {
    
    // MARK: - Properties
    
    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [WordCard]
    @Query private var progressList: [UserProgress]

    @State private var flipped = false
    @State private var currentIndex = 0
    @State private var userInput = ""
    @State private var feedbackColor: Color? = nil
    @State private var xp = 0
    private var progress: UserProgress {
        if let existing = progressList.first {
            return existing
        } else {
            let newProgress = UserProgress()
            modelContext.insert(newProgress)
            return newProgress
        }
    }

    
    // MARK: - init

    var body: some View {
        mainView
    }

    // MARK: - Views
    
    private var mainView: some View {
        VStack(spacing: 24) {
            if cards.isEmpty {
                Text("No cards yet. Add some!")
                    .foregroundColor(.gray)
            } else {
                flashCardView
                buttonView
            }
        }
        .padding()
        .navigationTitle("PocketWords")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                naivigateToAddCardView
            }
        }
    }
    
    private var naivigateToAddCardView: some View {
        NavigationLink {
            AddCardView()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder
    private var flashCardView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(height: 200)
                .overlay(
                    Text(flipped ? cards[currentIndex].meaning : cards[currentIndex].word)
                        .font(.title)
                        .foregroundColor(.white)
                        .accessibilityLabel(flipped ? cards[currentIndex].meaning : cards[currentIndex].word)
                        .accessibilityHint("Double tap to flip the card.")
                )
                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        flipped.toggle()
                    }
                }
        }
        
        TextField("Enter meaning", text: $userInput)
            .textFieldStyle(.roundedBorder)
            .border(feedbackColor ?? .clear, width: 2)
            .padding(.horizontal)
            .onSubmit {
                checkAnswer()
            }
            .accessibilityLabel("Meaning input field")
            .accessibilityHint("Type your guess for the meaning and press return.")

        progressView
    }
    
    private var progressView: some View {
        let totalXP = max(1, cards.count * 10)
        return VStack(spacing: 8) {
            ProgressView(value: Double(progress.xp), total: Double(totalXP))
                .progressViewStyle(.linear)
                .tint(.green)
                .frame(height: 10)

            Text("XP: \(progress.xp) / \(totalXP)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var buttonView: some View {
        HStack {
            Button("Previous") {
                currentIndex = max(0, currentIndex - 1)
                reset()
            }
            Spacer()
            Button("Next") {
                currentIndex = min(cards.count - 1, currentIndex + 1)
                reset()
            }
        }
        .padding(.horizontal)
    }
    
    // MARK: - Functions

    private func checkAnswer() {
        let correct = cards[currentIndex].meaning
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let input = userInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if input == correct {
            feedbackColor = .green
            progress.xp = min(progress.xp + 10, cards.count * 10)
        } else {
            feedbackColor = .red
        }

        do {
            try modelContext.save()
        } catch {
            Logger.os.debug("❌ Error saving progress: \(error.localizedDescription)")
        }
    }


    private func reset() {
        userInput = ""
        feedbackColor = nil
        flipped = false
    }
}


// MARK: - Preview

#Preview {
    NavigationView {
        FlashcardView()
    }
}
