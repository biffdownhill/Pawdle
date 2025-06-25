//
//  Colors.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Text Colors
    let textPrimary = Color("TextPrimary")
    let textSecondary = Color("TextSecondary")
    let textTertiary = Color("TextTertiary")
    
    // Background Colors
    let backgroundPrimary = Color("BackgroundPrimary")
    let backgroundSecondary = Color("BackgroundSecondary")
    let backgroundTertiary = Color("BackgroundTertiary")
    
    // Accent Colors
    let accent = Color("AccentColor")
    let accentSecondary = Color("AccentSecondary")
    let accentForeground = Color("AccentForeground")
    
    // Fill Colors
    let fill = Color("Fill")
    let fillSecondary = Color("FillSecondary")
    let fillTertiary = Color("FillTertiary")
    
    // Semantic Colors
    let success = Color("Success")
    let warning = Color("Warning")
    let error = Color("Error")
}
