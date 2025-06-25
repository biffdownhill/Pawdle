//
//  QuestionView.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

/// A comprehensive view component for displaying quiz questions with multiple states.
struct QuestionView: View {
    private let question: GameQuestion
    @Binding private var selectedBreed: DogBreed?
    
    init(
        question: GameQuestion,
        selectedBreed: Binding<DogBreed?>
    ) {
        self.question = question
        self._selectedBreed = selectedBreed
    }
    
    var body: some View {
        VStack(spacing: Size.xl.rawValue) {
            // Result message (only shown when answered)
            if let selectedBreed {
                VStack(spacing: Size.sm.rawValue) {
                    Text(selectedBreed == question.correctBreed ? "Correct! 🎉" : "Not quite! 🤔")
                        .textStyle(.title2)
                        .foregroundColor(selectedBreed == question.correctBreed ? Color.theme.success : Color.theme.error)
                    
                    if selectedBreed != question.correctBreed {
                        Text("This is a \(question.correctBreed.name)")
                            .textStyle(.body)
                            .foregroundColor(Color.theme.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
            } else {
                // Question prompt (only shown when playing)
                Text("What breed is this?")
                    .textStyle(.title2)
                    .foregroundColor(Color.theme.textPrimary)
                    .multilineTextAlignment(.center)
            }
            
            // Dog image
            GeometryReader { geometry in
                DogImageCard(question.imageURL, maxWidth: geometry.size.width * 0.8, maxHeight: geometry.size.height * 0.8)
                    .transition(
                        .asymmetric(
                            insertion: .scale,
                            removal: .offset(x: .random(in: -20...20), y: .random(in: -20...0))
                        )
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // To center align the card
            }
            
            // Answer options
            VStack(spacing: Size.lg.rawValue) {
                ForEach(question.options) { breed in
                    let state: AnswerButtonState = {
                        guard let selectedBreed else { return .default }
                        if breed == question.correctBreed {
                            return .correct
                        } else {
                            return breed == selectedBreed ? .wrong : .default
                        }
                    }()
                    AnswerButton(
                        breed: breed,
                        state: state,
                        selectedBreed: $selectedBreed
                    )
                }
            }
        }
    }
}

#if DEBUG
private struct QuestionViewContainer: View {
    @State private var selectedBreed: DogBreed? = nil
    
    var body: some View {
        QuestionView(
            question: GameQuestion(
                correctBreed: DogBreed(id: "afghan", name: "Afghan Hound"),
                imageURL: URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg")!,
                allBreeds: [
                    DogBreed(id: "afghan", name: "Afghan Hound"),
                    DogBreed(id: "beagle", name: "Beagle"),
                    DogBreed(id: "labrador", name: "Labrador"),
                    DogBreed(id: "husky", name: "Husky")
                ]
            ),
            selectedBreed: $selectedBreed
        )
        .padding()
    }
}
#Preview {
    QuestionViewContainer()
}
#endif 
