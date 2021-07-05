//
//  Sequence.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 05.07.2021.
//

import Foundation

extension Sequence {
    func toDictionary<Key: Hashable>(with mapping: (Iterator.Element) -> (Key, Any)?) -> [Key: Any] {
        Dictionary(uniqueKeysWithValues: compactMap(mapping))
    }
}
