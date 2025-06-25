//
//  GameQuestion.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import Foundation

struct GameQuestion: Equatable {
    let correctBreed: DogBreed
    let imageURL: URL
    let options: [DogBreed]
    
    init(correctBreed: DogBreed, imageURL: URL, allBreeds: [DogBreed]) {
        self.correctBreed = correctBreed
        self.imageURL = imageURL
        
        // Create 4 options including the correct answer
        var options = [correctBreed]
        let otherBreeds = allBreeds.filter { $0 != correctBreed }.shuffled()
        options.append(contentsOf: Array(otherBreeds.prefix(3)))
        
        self.options = options.shuffled()
    }
}

// MARK: - Stub Factory

extension GameQuestion {
    /// Creates a stub GameQuestion with predictable test data
    static func stub(correctBreedId: String = "0") -> GameQuestion {
        let allBreeds = Array<DogBreed>.stub(withCount: 8)
        let correctBreed = DogBreed.stub(withId: correctBreedId)
        let imageURL = URL(string: "https://images.dog.ceo/breeds/\(correctBreedId)/test.jpg")!
        
        return GameQuestion(
            correctBreed: correctBreed,
            imageURL: imageURL,
            allBreeds: allBreeds
        )
    }
    
    /// Creates a stub GameQuestion with a specific correct breed
    static func stub(withCorrectBreed breed: DogBreed) -> GameQuestion {
        let allBreeds = Array<DogBreed>.stub(withCount: 8)
        let imageURL = URL(string: "https://images.dog.ceo/breeds/\(breed.id)/test.jpg")!
        
        return GameQuestion(
            correctBreed: breed,
            imageURL: imageURL,
            allBreeds: allBreeds
        )
    }
}
