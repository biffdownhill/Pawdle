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
    
    @Test("GameViewModel starts game successfully")
    func gameViewModel_startGame_success() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        await viewModel.startGame()
        
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
        
        await viewModel.startGame()
        
        // Get the current question
        guard case .playing(let question) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(question.correctBreed)
        
        #expect(viewModel.selectedBreed == question.correctBreed)
        #expect(viewModel.isCorrect == true)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.2) == true, "Progress should be 0.1 after correct answer")
        
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
        
        await viewModel.startGame()
        
        // Get the current question
        guard case .playing(let question) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        let wrongBreed = question.options.first { $0 != question.correctBreed }!
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
        
        await viewModel.startGame()
        
        // Answer current question
        guard case .playing(let firstQuestion) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(firstQuestion.correctBreed)
        #expect(viewModel.selectedBreed == firstQuestion.correctBreed)
        
        await viewModel.loadNextQuestion()
        
        #expect(viewModel.selectedBreed == nil)
        
        if case .playing(let secondQuestion) = viewModel.gameState {
            // Should have a new question (might be the same breed but different image)
            #expect(secondQuestion.options.count == 4)
        } else {
            Issue.record("Expected playing state after next question")
        }
    }
    
    @Test("GameViewModel progress increases and decreases correctly")
    func gameViewModel_progress() async throws {
        let viewModel = GameViewModel(
            dogRepository: .mock(),
            imageRepository: .mock()
        )
        
        await viewModel.startGame()
        
        // First get some progress
        guard case .playing(let firstQuestion) = viewModel.gameState else {
            Issue.record("Expected playing state")
            return
        }
        
        viewModel.selectAnswer(firstQuestion.correctBreed)
        #expect(viewModel.progress?.isApproximatelyEqual(to: 0.2) == true, "Progress should be 0.1 after correct answer")
        
        await viewModel.loadNextQuestion()
        
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
