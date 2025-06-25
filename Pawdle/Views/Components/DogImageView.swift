//
//  DogImageView.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

struct DogImageView: View {
    let imageURL: URL
    let contentMode: ContentMode
    
    init(_ imageURL: URL, contentMode: ContentMode = .fill) {
        self.imageURL = imageURL
        self.contentMode = contentMode
    }
    
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            VStack(spacing: Size.sm.rawValue) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.theme.accent))
                
                Text("Loading image...")
                    .textStyle(.caption)
                    .foregroundColor(Color.theme.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color.theme.fillSecondary
        }
    }
}

struct DogImageCard: View {
    let imageURL: URL
    let aspectRatio: CGFloat
    
    init(_ imageURL: URL, aspectRatio: CGFloat = 1.0) {
        self.imageURL = imageURL
        self.aspectRatio = aspectRatio
    }
    
    var body: some View {
        DogImageView(imageURL)
            .aspectRatio(aspectRatio, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: Size.md.rawValue))
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: Size.lg.rawValue) {
        // Square dog image
        DogImageCard(URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!)
            .frame(width: 200, height: 200)
        
        // Rectangle dog image
        DogImageCard(URL(string: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")!, aspectRatio: 4/3)
            .frame(width: 300, height: 225)
    }
    .padding()
} 
#endif
