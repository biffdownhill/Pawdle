//
//  PawdleButton.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

enum PawdleButtonVariant {
    case primary
    case secondary
}

struct PawdleButtonStyle: ButtonStyle {
    var variant: PawdleButtonVariant
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textStyle(.button)
            .foregroundColor(Color.theme.accentForeground)
            .frame(maxWidth: .infinity)
            .frame(height: Size.xxxxl.rawValue)
            .background(
                RoundedRectangle(cornerRadius: Size.sm.rawValue)
                    .fill(Color.theme.accent)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct PawdleButton: View {
    let title: String
    let variant: PawdleButtonVariant
    let action: () -> Void
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    
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
