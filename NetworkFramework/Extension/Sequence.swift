//
//  Sequence.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 05.07.2021.
//

import Foundation

extension Sequence where Element == Mirror.Child {
    func toDictionary<Key: Hashable>(with mapping: (Iterator.Element) -> (Key, Any)?) -> [Key: Any] {
        Dictionary(uniqueKeysWithValues: compactMap(mapping))
    }
}

extension Sequence where Element == Character {
    func splitBefore(
        separator isSeparator: (Iterator.Element) throws -> Bool
    ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []
        var iterator = makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                result.append(AnySequence(subSequence))
                subSequence = [element]
            } else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}
