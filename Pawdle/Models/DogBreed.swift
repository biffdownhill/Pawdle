//
//  DogBreed.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import Foundation

struct DogBreed: Identifiable, Equatable, Codable {
    let id: String
    let name: String
}

// MARK: - Stubbable Conformance

extension DogBreed: Stubbable {
    static func stub(withId id: String) -> DogBreed {
        let breedNames = [
            "Labrador Retriever",
            "Golden Retriever", 
            "German Shepherd",
            "Bulldog",
            "Beagle",
            "Poodle",
            "Rottweiler",
            "Yorkshire Terrier",
            "Husky",
            "Border Collie"
        ]
        
        // Use a simple hash of the id to pick a consistent breed name
        let index = abs(id.hashValue) % breedNames.count
        let breedName = breedNames[index]
        
        return DogBreed(
            id: id,
            name: breedName
        )
    }
}
