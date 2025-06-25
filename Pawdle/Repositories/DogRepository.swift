//
//  DogRepository.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

struct DogRepository {
    let fetchAllBreeds: () async throws -> [DogBreed]
    let fetchRandomImageUrl: (_ breed: DogBreed) async throws -> URL
}

private extension DogRepository {
    static func flattenBreeds(_ breeds: [String: [String]]) -> [DogBreed] {
        return breeds.flatMap { mainBreed, subBreeds in
            if subBreeds.isEmpty {
                return [DogBreed(id: mainBreed, name: formatBreedName(mainBreed))]
            } else {
                return subBreeds.map { subBreed in
                    DogBreed(id: "\(mainBreed)-\(subBreed)", name: formatSubBreedName(mainBreed: mainBreed, subBreed: subBreed))
                }
            }
        }
    }
    
    static func formatBreedName(_ breed: String) -> String {
        return breed
            .capitalized
    }
    
    static func formatSubBreedName(mainBreed: String, subBreed: String) -> String {
        let formattedMainBreed = mainBreed
            .capitalized
        
        let formattedSubBreed = subBreed
            .capitalized
        
        return "\(formattedSubBreed) \(formattedMainBreed)"
    }
    
    static func formatBreedForRequest(_ breed: DogBreed) -> String {
        return breed.id.replacingOccurrences(of: "-", with: "/")
    }
}

extension DogRepository {
    static func live() -> Self {
        Self(
            fetchAllBreeds: {
                let url = Routes.DogCEO.allBreeds
                let networkManager = NetworkManager()
                let response = try await networkManager.get(endpoint: url, responseType: AllBreedsResponse.self)
                let breeds = response.message
                return flattenBreeds(breeds)
            },
            fetchRandomImageUrl: { breed in
                let formattedBreed = formatBreedForRequest(breed)
                let url = Routes.DogCEO.image(breed: formattedBreed)
                let networkManager = NetworkManager()
                let response = try await networkManager.get(endpoint: url, responseType: RandomImageUrlResponse.self)
                guard let imageUrl = URL(string: response.message) else {
                    throw NetworkError.decodingError
                }
                return imageUrl
            }
        )
    }
    
    static func mock() -> Self {
        return Self(
            fetchAllBreeds: {
                return [
                    DogBreed(id: "labrador", name: "Labrador"),
                    DogBreed(id: "bulldog", name: "Bulldog"),
                    DogBreed(id: "beagle", name: "Beagle"),
                    DogBreed(id: "poodle", name: "Poodle"),
                    DogBreed(id: "german shepherd", name: "German Shepherd"),
                    DogBreed(id: "golden retriever", name: "Golden Retriever"),
                ]
            },
            fetchRandomImageUrl: { breed in
                return URL(string: "https://picsum.photos/200")!
            }
        )
    }
}
