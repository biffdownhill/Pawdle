//
//  DogImageCard.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

/// A reusable card component for displaying dog images with loading and error states.
struct DogImageCard: View {
    let imageURL: URL
    let maxWidth: CGFloat
    let maxHeight: CGFloat
    
    /// Initializes a DogImageCard with the specified image URL and optional maximum dimensions.
    /// - Parameters:
    ///  - imageURL: The URL of the dog image to display.
    ///  - maxWidth: The maximum width of the image card. Default is `.infinity`.
    ///  - maxHeight: The maximum height of the image card. Default is `.infinity`.
    init(_ imageURL: URL, maxWidth: CGFloat = .infinity, maxHeight: CGFloat = .infinity) {
        self.imageURL = imageURL
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            VStack(spacing: Size.sm.rawValue) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.accent))
                
                Text("Loading image...")
                    .textStyle(.caption)
                    .foregroundColor(Color.theme.textSecondary)
            }
            .frame(width: maxWidth * 0.8, height: maxHeight * 0.8)
        }
        .background {
            Color.theme.fillSecondary
        }
        .clipShape(RoundedRectangle(cornerRadius: Size.xxl.rawValue))
        .scaledToFit()
        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: Size.lg.rawValue) {
        // Square dog image
        DogImageCard(URL(string: "https://picsum.photos/200")!)
            .frame(width: 200, height: 200)
        
        // Rectangle dog image
        DogImageCard(URL(string: "https://picsum.photos/200")!)
            .frame(width: 300, height: 225)
    }
    .padding()
} 
#endif
