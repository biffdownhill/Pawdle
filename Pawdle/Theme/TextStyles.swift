//
//  TextStyles.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

// MARK: - Text Style Enum
enum TextStyle {
    case largeTitle
    case title1
    case title2
    case title3
    case headline
    case body
    case bodyLarge
    case callout
    case caption
    case caption2
    case footnote
    case button
    
    var font: Font {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title1:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .bodyLarge:
            return .title3
        case .callout:
            return .callout
        case .caption:
            return .caption
        case .caption2:
            return .caption2
        case .footnote:
            return .footnote
        case .button:
            return .headline
        }
    }
    
    var weight: Font.Weight {
        switch self {
        case .largeTitle, .title1, .title2, .title3, .headline:
            return .semibold
        case .bodyLarge:
            return .medium
        case .button:
            return .semibold
        case .body, .callout, .caption, .caption2, .footnote:
            return .regular
        }
    }
    
    var lineSpacing: CGFloat {
        switch self {
        case .largeTitle, .title1:
            return 2
        case .title2, .title3, .headline:
            return 1
        case .body, .bodyLarge, .callout:
            return 0.5
        case .caption, .caption2, .footnote, .button:
            return 0
        }
    }
}

// MARK: - View Extension for Text Styles
extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self
            .font(style.font.weight(style.weight))
            .lineSpacing(style.lineSpacing)
    }
}
