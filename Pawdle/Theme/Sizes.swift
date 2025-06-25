//
//  Sizes.swift
//  Pawdle
//
//  Created by Edward Downhill on 24/06/2025.
//

import SwiftUI

// MARK: - Size Enum
enum Size: CGFloat, CaseIterable {
    case zero = 0
    case xxs = 2
    case xs = 4
    case sm = 8
    case md = 12
    case lg = 16
    case xl = 20
    case xxl = 24
    case xxxl = 32
    case xxxxl = 40
    case xxxxxl = 48
}

// MARK: - View Extensions for Sizes
extension View {
    func padding(_ size: Size) -> some View {
        self.padding(size.rawValue)
    }
    
    func padding(_ edges: Edge.Set = .all, _ size: Size) -> some View {
        self.padding(edges, size.rawValue)
    }
    
    func cornerRadius(_ size: Size) -> some View {
        self.cornerRadius(size.rawValue)
    }
    
    func frame(width: Size? = nil, height: Size? = nil) -> some View {
        self.frame(
            width: width?.rawValue,
            height: height?.rawValue
        )
    }
    
    func frame(size: Size) -> some View {
        self.frame(width: size.rawValue, height: size.rawValue)
    }
}

// MARK: - EdgeInsets Extension
extension EdgeInsets {
    init(_ size: Size) {
        self.init(top: size.rawValue, leading: size.rawValue, bottom: size.rawValue, trailing: size.rawValue)
    }
    
    init(top: Size = .zero, leading: Size = .zero, bottom: Size = .zero, trailing: Size = .zero) {
        self.init(top: top.rawValue, leading: leading.rawValue, bottom: bottom.rawValue, trailing: trailing.rawValue)
    }
}
