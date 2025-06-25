//
//  Double+isApproxEqual.swift
//  Pawdle
//
//  Created by Edward Downhill on 25/06/2025.
//

import Foundation
import Testing

extension Double {
    /// Checks if two doubles are approximately equal within a given tolerance
    /// This is essential for floating point comparisons in tests
    func isApproximatelyEqual(to other: Double, tolerance: Double = 0.000001) -> Bool {
        return abs(self - other) < tolerance
    }
}

/// Custom expectation for approximate double equality
/// Use this for floating point comparisons in tests to avoid precision issues
func expectApproximatelyEqual(
    _ actual: Double,
    _ expected: Double,
    tolerance: Double = 0.000001,
    _ message: String = ""
) {
    #expect(
        actual.isApproximatelyEqual(to: expected, tolerance: tolerance),
        "\(message.isEmpty ? "" : "\(message): ")Expected \(expected), got \(actual) (tolerance: \(tolerance))"
    )
}
