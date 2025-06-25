//
//  PawdleButton.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

/// Button variant styles for PawdleButton component.
enum PawdleButtonVariant {
    case primary
    case secondary
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .theme.accent
        case .secondary:
            return .clear
        }
    }
    
    var borderColor: Color {
        switch self {
        case .primary:
            return .clear
        case .secondary:
            return .theme.accent
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary:
            return .theme.accentForeground
        case .secondary:
            return .theme.accent
        }
    }
}

/// Custom button style that provides consistent styling for PawdleButton variants.
struct PawdleButtonStyle: ButtonStyle {
    var variant: PawdleButtonVariant
    var fillParent: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.button)
            .foregroundColor(variant.foregroundColor)
            .padding(.vertical, Size.md.rawValue)
            .padding(.horizontal, Size.lg.rawValue)
            .frame(maxWidth: fillParent ? .infinity : nil)
            .background(
                Capsule()
                    .fill(variant.backgroundColor)
            )
            .overlay {
                Capsule()
                    .stroke(variant.borderColor, lineWidth: Size.xxs.rawValue)
            }
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// A reusable button component with consistent styling and multiple variants.
struct PawdleButton: View {
    let title: String
    let variant: PawdleButtonVariant
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
    /// Initializes a PawdleButton with a title, variant, and action closure.
    /// - Parameters:
    /// - title: The text to display on the button.
    /// - variant: The button style variant. Defaults to `.primary`.
    /// - action: The closure to execute when the button is tapped.
    init(
        _ title: String,
        variant: PawdleButtonVariant = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(PawdleButtonStyle(variant: variant))
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: Size.lg.rawValue) {
        PawdleButton("Primary Button") {
            print("Primary tapped")
        }
        
        PawdleButton("Secondary Button", variant: .secondary) {
            print("Secondary tapped")
        }
    }
    .padding()
}
#endif
