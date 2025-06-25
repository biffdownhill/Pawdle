//
//  GameViewModelTests.swift
//  PawdleTests
//
//  Created by Edward Downhill on 24/06/2025.
//

import Testing
import SwiftUI
@testable import Pawdle

/// Unit tests for GameViewModel
@MainActor
struct GameViewModelTests {
    
    // MARK: - Initialization Tests
    
    @Test("GameViewModel initializes with correct default state")
    func gameViewModel_initialization() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        #expect(viewModel.gameState == .loading)
        #expect(viewModel.selectedBreed == nil)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.0) == true, "Progress should be initialized to 0.0")
        #expect(viewModel.isCorrect == false)
    }
    
    // MARK: - Game Flow Tests
    
    @Test("GameViewModel starts game successfully")
    func gameViewModel_startGame_success() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        
        // Allow async operations to complete
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Should transition from loading to playing
        if case .playing(let question) = viewModel.gameState {
            #expect(question.options.count == 4)
        } else {
            Issue.record("Expected playing state, got \(viewModel.gameState)")
        }
    }
    
    @Test("GameViewModel handles correct answer selection")
    func gameViewModel_selectCorrectAnswer() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Get the current question
        guard case .playing(let question) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        // Select correct answer
        viewModel.selectAnswer(question.correctBreed)
        
        #expect(viewModel.selectedBreed == question.correctBreed)
        #expect(viewModel.isCorrect == true)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.1) == true, "Progress should be 0.1 after correct answer")
        
        if case .answered(let answeredQuestion) = viewModel.gameState {
            #expect(answeredQuestion.correctBreed == question.correctBreed)
        } else {
            Issue.record("Expected answered state")
        }
    }
    
    @Test("GameViewModel handles wrong answer selection")
    func gameViewModel_selectWrongAnswer() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Get the current question
        guard case .playing(let question) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        // Find a wrong answer
        let wrongBreed = question.options.first { $0 != question.correctBreed }!
        
        // Select wrong answer
        viewModel.selectAnswer(wrongBreed)
        
        #expect(viewModel.selectedBreed == wrongBreed)
        #expect(viewModel.isCorrect == false)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.0) == true, "Progress should remain at 0.0")
        
        if case .answered(let answeredQuestion) = viewModel.gameState {
            #expect(answeredQuestion.correctBreed == question.correctBreed)
        } else {
            Issue.record("Expected answered state")
        }
    }
    
    @Test("GameViewModel proceeds to next question")
    func gameViewModel_nextQuestion() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Answer current question
        guard case .playing(let firstQuestion) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(firstQuestion.correctBreed)
        #expect(viewModel.selectedBreed == firstQuestion.correctBreed)
        
        // Move to next question
        viewModel.nextQuestion()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.selectedBreed == nil)
        
        if case .playing(let secondQuestion) = viewModel.gameState {
            // Should have a new question (might be the same breed but different image)
            #expect(secondQuestion.options.count == 4)
        } else {
            Issue.record("Expected playing state after next question")
        }
    }
    
    @Test("GameViewModel resets game correctly")
    func gameViewModel_resetGame() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        // Start and play a game
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        guard case .playing(let question) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(question.correctBreed)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.1) == true, "Progress should be 0.1 after correct answer")
        
        // Reset the game
        viewModel.resetGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.0) == true, "Progress should be reset to 0.0")
        #expect(viewModel.selectedBreed == nil)
        
        if case .playing(_) = viewModel.gameState {
            // Should be back to playing state
        } else {
            Issue.record("Expected playing state after reset")
        }
    }
    
    // MARK: - Progress Tests
    
    @Test("GameViewModel progress increases correctly with correct answers")
    func gameViewModel_progressIncreases() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Answer 3 questions correctly
        let expectedProgressValues = [0.1, 0.2, 0.3]
        
        for (index, expectedProgress) in expectedProgressValues.enumerated() {
            guard case .playing(let question) = viewModel.gameState else {
                Issue.record("Expected playing state at iteration \(index)")
                return
            }
            
            viewModel.selectAnswer(question.correctBreed)
            #expect(viewModel.progress?.isApproximatelyEqual(to: expectedProgress) == true, "Progress should be \(expectedProgress) after \(index + 1) correct answers")
            
            // Don't call nextQuestion after the last iteration
            if index < expectedProgressValues.count - 1 {
                viewModel.nextQuestion()
                try await Task.sleep(nanoseconds: 100_000_000)
            }
        }
    }
    
    @Test("GameViewModel progress decreases correctly with wrong answers")
    func gameViewModel_progressDecreases() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        viewModel.startGame()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // First get some progress
        guard case .playing(let firstQuestion) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(firstQuestion.correctBreed)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.1) == true, "Progress should be 0.1 after correct answer")
        
        viewModel.nextQuestion()
        try await Task.sleep(nanoseconds: 100_000_000)
        
        // Now answer wrong
        guard case .playing(let secondQuestion) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        let wrongBreed = secondQuestion.options.first { $0 != secondQuestion.correctBreed }!
        viewModel.selectAnswer(wrongBreed)
        
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.0) == true, "Progress should decrease to 0.0 after wrong answer")
    }
}
