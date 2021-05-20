//
//  Encodable.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 17.04.2021.
//

import Foundation

extension Encodable {

    func toQueryItem(with encoder: JSONEncoder) -> [URLQueryItem]? {
        guard let dictionary = asDictionary(with: encoder) else { return nil }
        return dictionary
            .compactMapValues { String(describing: $0) }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    func asDictionary(with encoder: JSONEncoder) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}
