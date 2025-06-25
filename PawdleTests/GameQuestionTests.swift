//
//  RepositoryTests.swift
//  PawdleTests
//
//  Created by Edward Downhill on 24/06/2025.
//

import Testing
import Foundation
@testable import Pawdle

/// Unit tests for Repository implementations
struct GameQuestionTests {
    @Test("GameQuestion model handles specific breeds")
    func gameQuestion_model_specificBreed() {
        let specificBreed = DogBreed.stub(withId: "golden-retriever")
        let question = GameQuestion.stub(withCorrectBreed: specificBreed)
        
        #expect(question.correctBreed == specificBreed)
        #expect(question.options.contains(specificBreed))
        #expect(question.options.count == 4)
        
        // Check that all options are unique
        let uniqueOptions = Set(question.options.map { $0.id })
        #expect(uniqueOptions.count == 4)
    }
}
