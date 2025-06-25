//
//  ImageRepository.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

struct ImageRepository {
    let loadImage: (_ url: URL) async throws -> UIImage
}

extension ImageRepository {
    static func live() -> Self {
        return Self(
            loadImage: { url in
                let networkManager = NetworkManager()
                let data = try await networkManager.request(
                    endpoint: url,
                    responseType: Data.self
                )
                guard let image = UIImage(data: data) else {
                    throw NetworkError.decodingError
                }
                return image
            }
        )
    }
    
    static func mock() -> Self {
        return Self(
            loadImage: { url in
                return UIImage(systemName: "example.dog") ?? UIImage()
            }
        )
    }
}
