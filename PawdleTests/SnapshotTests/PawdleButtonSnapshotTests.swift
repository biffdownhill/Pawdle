//
//  ComponentSnapshotTests.swift
//  PawdleTests
//
//  Created by Edward Downhill on 25/06/2025.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import Pawdle

/// Snapshot tests for individual UI components
@MainActor
struct PawdleButtonSnapshotTests {
    
    // MARK: - PawdleButton Tests
    
    @Test("PawdleButton primary variant - light mode")
    func pawdleButton_primary_lightMode() async throws {
        let button = PawdleButton("Primary Button") { }
            .padding()
            .background(Color.theme.backgroundPrimary)
        
        assertSnapshot(
            of: button,
            as: .image(layout: .fixed(width: 300, height: 200))
        )
    }
    
    @Test("PawdleButton primary variant - dark mode")
    func pawdleButton_primary_darkMode() async throws {
        let button = PawdleButton("Primary Button") { }
            .padding()
            .background(Color.theme.backgroundPrimary)
            .environment(\.colorScheme, .dark)
        
        assertSnapshot(
            of: button,
            as: .image(layout: .fixed(width: 300, height: 200))
        )
    }
    
    @Test("PawdleButton secondary variant - light mode")
    func pawdleButton_secondary_lightMode() async throws {
        let button = PawdleButton("Secondary Button", variant: .secondary) { }
            .padding()
            .background(Color.theme.backgroundPrimary)
        
        assertSnapshot(
            of: button,
            as: .image(layout: .fixed(width: 300, height: 200))
        )
    }
    
    @Test("PawdleButton secondary variant - dark mode")
    func pawdleButton_secondary_darkMode() async throws {
        let button = PawdleButton("Secondary Button", variant: .secondary) { }
            .padding()
            .background(Color.theme.backgroundPrimary)
            .environment(\.colorScheme, .dark)
        
        assertSnapshot(
            of: button,
            as: .image(layout: .fixed(width: 300, height: 200))
        )
    }
} 
