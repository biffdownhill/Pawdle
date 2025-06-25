//
//  StubArrayExtension.swift
//  SynergyTradeCenter
//
//  Created by Edward Downhill on 03/10/2023.
//

import Foundation

extension Array where Element: Stubbable, Element.ID == String {
    static func stub(withCount count: Int) -> Array {
        guard count > 0 else { return [] }
        return (0..<count).map {
            .stub(withId: "\($0)")
        }
    }
}
extension Array where Element: Stubbable, Element.ID == Int {
    static func stub(withCount count: Int) -> Array {
        guard count > 0 else { return [] }
        return (0..<count).map {
            .stub(withId: $0)
        }
    }
}
extension Array where Element: Stubbable, Element.ID == Int64 {
    static func stub(withCount count: Int64) -> Array {
        guard count > 0 else { return [] }
        return (0..<count).map {
                .stub(withId: $0)
        }
    }
}

extension MutableCollection where Element: Stubbable {
    func setting<T>(_ keyPath: WritableKeyPath<Element, T>,
                    to value: T) -> Self {
        var collection = self

        for index in collection.indices {
            let element = collection[index]
            collection[index] = element.setting(keyPath, to: value)
        }

        return collection
    }
}
