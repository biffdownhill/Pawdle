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
