//
//  ContentView.swift
//  pocketWords
//
//  Created by Mohammad on 5/12/25.
//

import SwiftUI
import SwiftData

struct FlashcardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var cards: [WordCard]

    @State private var flipped = false
    @State private var currentIndex = 0
    @State private var userInput = ""
    @State private var feedbackColor: Color? = nil
    @State private var xp = 0

    var body: some View {
        VStack(spacing: 24) {
            if cards.isEmpty {
                Text("No cards yet. Add some!")
                    .foregroundColor(.gray)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue)
                        .frame(height: 200)
                        .overlay(
                            Text(flipped ? cards[currentIndex].meaning : cards[currentIndex].word)
                                .font(.title)
                                .foregroundColor(.white)
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

//                ProgressView(value: Double(xp), total: Double(cards.count * 10))
//                    .padding(.horizontal)

                VStack(spacing: 8) {
                    ProgressView(value: Double(xp), total: Double(cards.count * 10))
                        .progressViewStyle(.linear)
                        .tint(.green)
                        .frame(height: 10)

                    Text("XP: \(xp) / \(cards.count * 10)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)

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
        }
        .padding()
        .navigationTitle("PocketWords")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    AddCardView()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func checkAnswer() {
        let correct = cards[currentIndex]
            .meaning
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        let input = userInput
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if input == correct {
            feedbackColor = .green
            xp += 10
        } else {
            feedbackColor = .red
        }
    }

    private func reset() {
        userInput = ""
        feedbackColor = nil
        flipped = false
    }
}

#Preview {
    NavigationView {
        FlashcardView()
    }
}
