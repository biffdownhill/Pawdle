//
//  HomeViewSnapshotTests.swift
//  PawdleTests
//
//  Created by Edward Downhill on 25/06/2025.
//

import Testing
import SwiftUI
import SnapshotTesting
@testable import Pawdle

/// Snapshot tests for HomeView in different states
@MainActor
struct HomeViewSnapshotTests {
    
    @Test("HomeView loading state - light mode")
    func homeView_loadingState_lightMode() async throws {
        let mockDogRepo = DogRepository.mock()
        let mockImageRepo = ImageRepository.mock()
        
        let homeView = HomeView(
            dogRepository: mockDogRepo,
            imageRepository: mockImageRepo
        )
        .frame(width: 375, height: 812)
        
        assertSnapshot(of: homeView, as: .image(layout: .device(config: .iPhone13)))
    }
    
    @Test("HomeView loading state - dark mode")
    func homeView_loadingState_darkMode() async throws {
        let mockDogRepo = DogRepository.mock()
        let mockImageRepo = ImageRepository.mock()
        
        let homeView = HomeView(
            dogRepository: mockDogRepo,
            imageRepository: mockImageRepo
        )
        .environment(\.colorScheme, .dark)
        .frame(width: 375, height: 812)
        
        assertSnapshot(of: homeView, as: .image(layout: .device(config: .iPhone13)))
    }
}
