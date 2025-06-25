//
//  AnswerButtonState.swift
//  Pawdle
//
//  Created by Edward Downhill on 25/06/2025.
//

import SwiftUI

enum AnswerButtonState {
    case `default`
    case correct
    case wrong
    
    var backgroundColor: Color {
        switch self {
        case .default:
            return Color.theme.backgroundSecondary
        case .correct:
            return Color.theme.success.opacity(0.2)
        case .wrong:
            return Color.theme.error.opacity(0.2)
        }
    }
    
    var textColor: Color {
        switch self {
        case .default:
            return Color.theme.textPrimary
        case .correct:
            return Color.theme.success
        case .wrong:
            return Color.theme.error
        }
    }
    
    var borderColor: Color {
        switch self {
        case .default:
            return Color.theme.fillSecondary
        case .correct:
            return Color.theme.success
        case .wrong:
            return Color.theme.error
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .default:
            return Size.xxs.rawValue
        case .correct, .wrong:
            return 2
        }
    }
}
