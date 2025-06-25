//
//  GameViewModel.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import Foundation

// TODO: Migrate to using the @Observable macro when support for iOS 16 is dropped.
class GameViewModel: ObservableObject {
    @MainActor @Published private(set) var gameState: GameState = .loading
    @MainActor @Published var selectedBreed: DogBreed?
    @MainActor @Published private(set) var progress: Double? = 0.0
    
    private let numberOfQuestions: Double = 5
    
    private let dogRepository: DogRepository
    private let imageRepository: ImageRepository
    private var allBreeds: [DogBreed] = []
    
    @MainActor var isCorrect: Bool {
        guard let selectedBreed, case .answered(let question) = gameState else {
            return false
        }
        return selectedBreed == question.correctBreed
    }
    
    init(
        dogRepository: DogRepository = .live(),
        imageRepository: ImageRepository = .live()
    ) {
        self.dogRepository = dogRepository
        self.imageRepository = imageRepository
    }
    
    @MainActor
    func startGame() async {
        await loadBreeds()
    }
    
    @MainActor
    private func loadBreeds() async {
        gameState = .loading
        
        do {
            allBreeds = try await dogRepository.fetchAllBreeds()
            await loadNextQuestion()
        } catch {
            print("Error loading breeds: \(error)")
            gameState = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func loadNextQuestion() async {
        selectedBreed = nil
        
        guard !allBreeds.isEmpty else {
            gameState = .error("No breeds available")
            return
        }
        
        do {
            let randomBreed = allBreeds.randomElement()!
            let imageURL = try await dogRepository.fetchRandomImageUrl(randomBreed)
            
            // Create question with multiple choice options
            let question = GameQuestion(
                correctBreed: randomBreed,
                imageURL: imageURL,
                allBreeds: allBreeds
            )
            
            gameState = .playing(question)
        } catch {
            gameState = .error("Failed to load question: \(error.localizedDescription)")
            print("Error loading question: \(error)")
        }
    }
    
    @MainActor
    func selectAnswer(_ selectedBreed: DogBreed) {
        guard case .playing(let question) = gameState else { return }
        
        let isCorrect = selectedBreed == question.correctBreed
        
        if var progress {
            let change = 1.0 / numberOfQuestions
            if isCorrect {
                progress += change
            } else if progress >= change {
                progress -= change
            } else {
                progress = 0.0
            }
            
            self.progress = progress
        }
        
        // Check if game is completed
        if progress ?? 0 >= 1.0 {
            gameState = .completed
        } else {
            gameState = .answered(question)
        }
        
        self.selectedBreed = selectedBreed
    }
    
    @MainActor
    func continueInfinitePlay() {
        progress = nil
        Task {
            await loadNextQuestion()
        }
    }
}
