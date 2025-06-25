//
//  AnswerButton.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

/// A specialized button component for quiz answer options with multiple visual states.
struct AnswerButton: View {
    private let breed: DogBreed
    private let state: AnswerButtonState
    @Binding private var selectedBreed: DogBreed?
    
    var isAnswered: Bool {
        selectedBreed != nil
    }
    var isSelected: Bool {
        selectedBreed == breed
    }
    
    /// Initializes a new `AnswerButton`.
    /// - Parameters:
    /// - breed: The dog breed associated with this button.
    /// - correctBreed: The correct dog breed for the current question.
    /// - selectedBreed: The currently selected dog breed, if any.
    init(
        breed: DogBreed,
        state: AnswerButtonState,
        selectedBreed: Binding<DogBreed?>
    ) {
        self.breed = breed
        self.state = state
        self._selectedBreed = selectedBreed
    }
    
    var body: some View {
        Button {
            guard !isAnswered else { return } // Already answered
            selectedBreed = breed
        } label: {
            HStack {
                Text(breed.name)
                    .textStyle(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                switch state {
                case .correct, .wrong:
                    Image(systemName: state == .correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(state == .correct ? Color.theme.success : Color.theme.error)
                        .font(.system(size: Size.lg.rawValue))
                default:
                    EmptyView()
                }
            }
            .foregroundColor(state.textColor)
            .padding(.vertical, Size.md.rawValue)
            .padding(.horizontal, Size.lg.rawValue)
            .frame(maxWidth: .infinity)
            .background(
                Capsule()
                    .fill(state.backgroundColor)
            )
            .overlay {
                Capsule()
                    .stroke(state.borderColor, lineWidth: state.borderWidth)
            }
        }
        .disabled(isAnswered)
        .animation(.easeInOut(duration: 0.1), value: state)
    }
}

#if DEBUG
private struct AnswerButtonContainer: View {
    @State private var selectedBreed: DogBreed? = nil
    
    var body: some View {
        VStack(spacing: Size.md.rawValue) {
            // Normal state
            AnswerButton(
                breed: DogBreed(id: "labrador", name: "Labrador"),
                state: .default,
                selectedBreed: $selectedBreed
            )
            
            // Correct answer (answered)
            AnswerButton(
                breed: DogBreed(id: "husky", name: "Husky"),
                state: .correct,
                selectedBreed: $selectedBreed
            )
            
            // Wrong answer (answered)
            AnswerButton(
                breed: DogBreed(id: "bulldog", name: "Bulldog"),
                state: .wrong,
                selectedBreed: $selectedBreed
            )
        }
        .padding()
    }
}
#Preview {
    AnswerButtonContainer()
}
#endif
