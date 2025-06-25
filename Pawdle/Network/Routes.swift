//
//  Routes.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import Foundation

struct Routes {
    struct DogCEO {
        static let base = "https://dog.ceo/api"
        
        static let allBreeds = URL(string: "\(base)/breeds/list/all")!
        static func image(breed: String) -> URL {
            URL(string: "\(base)/breed/\(breed)/images/random")!
        }
    }
}
