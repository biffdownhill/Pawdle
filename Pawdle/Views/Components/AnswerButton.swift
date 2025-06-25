//
//  AnswerButton.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

struct AnswerButton: View {
    let breed: DogBreed
    let isSelected: Bool
    let isCorrect: Bool?
    let isAnswered: Bool
    let action: () -> Void
    
    init(
        breed: DogBreed,
        isSelected: Bool = false,
        isCorrect: Bool? = nil,
        isAnswered: Bool = false,
        action: @escaping () -> Void
    ) {
        self.breed = breed
        self.isSelected = isSelected
        self.isCorrect = isCorrect
        self.isAnswered = isAnswered
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(breed.name)
                    .textStyle(.body)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if isAnswered && isSelected {
                    Image(systemName: isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isCorrect == true ? Color.theme.success : Color.theme.error)
                        .font(.system(size: Size.lg.rawValue))
                }
            }
            .padding(.lg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .overlay(
                RoundedRectangle(cornerRadius: Size.sm.rawValue)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: Size.sm.rawValue))
        }
        .disabled(isAnswered)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: isAnswered)
    }
    
    // MARK: - Styling
    private var backgroundColor: Color {
        if isAnswered {
            if isSelected {
                return isCorrect == true ? Color.theme.success.opacity(0.2) : Color.theme.error.opacity(0.2)
            } else if isCorrect == true {
                return Color.theme.success.opacity(0.1)
            }
        } else if isSelected {
            return Color.theme.accent.opacity(0.1)
        }
        
        return Color.theme.backgroundSecondary
    }
    
    private var textColor: Color {
        if isAnswered {
            if isSelected {
                return isCorrect == true ? Color.theme.success : Color.theme.error
            } else if isCorrect == true {
                return Color.theme.success
            }
        }
        
        return Color.theme.textPrimary
    }
    
    private var borderColor: Color {
        if isAnswered {
            if isSelected {
                return isCorrect == true ? Color.theme.success : Color.theme.error
            } else if isCorrect == true {
                return Color.theme.success
            }
        } else if isSelected {
            return Color.theme.accent
        }
        
        return Color.theme.fillSecondary
    }
    
    private var borderWidth: CGFloat {
        if isAnswered && (isSelected || isCorrect == true) {
            return 2
        } else if isSelected {
            return 2
        }
        
        return 1
    }
}

#if DEBUG
#Preview {
    VStack(spacing: Size.md.rawValue) {
        // Normal state
        AnswerButton(
            breed: DogBreed(id: "labrador", name: "Labrador"),
        ) { }
        
        // Selected state
        AnswerButton(
            breed: DogBreed(id: "beagle", name: "Beagle"),
            isSelected: true
        ) { }
        
        // Correct answer (answered)
        AnswerButton(
            breed: DogBreed(id: "husky", name: "Husky"),
            isSelected: true,
            isCorrect: true,
            isAnswered: true
        ) { }
        
        // Wrong answer (answered)
        AnswerButton(
            breed: DogBreed(id: "bulldog", name: "Bulldog"),
            isSelected: true,
            isCorrect: false,
            isAnswered: true
        ) { }
        
        // Correct answer not selected (answered)
        AnswerButton(
            breed: DogBreed(id: "golden-retriever", name: "Golden Retriever"),
            isSelected: false,
            isCorrect: true,
            isAnswered: true
        ) { }
    }
    .padding()
}
#endif
