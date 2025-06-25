//
//  UIImage+createTestImage.swift
//  Pawdle
//
//  Created by Edward Downhill on 25/06/2025.
//

import SwiftUI

extension UIImage {
    /// Creates a simple test image with emoji
    static func createTestImage(size: CGSize = CGSize(width: 200, height: 200), emoji: String = "🐕") -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 80),
                .foregroundColor: UIColor.white
            ]
            
            let attributedString = NSAttributedString(string: emoji, attributes: attributes)
            let textSize = attributedString.size()
            let textRect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            
            attributedString.draw(in: textRect)
        }
    }
}
