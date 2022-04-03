//
//  RequestParametersProtocol.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 20.05.2021.
//

import Foundation

public protocol RequestParametersProtocol: Encodable {
    static var caseType: CaseTypes { get }
}

public extension RequestParametersProtocol {
    func toQueryItem() -> [URLQueryItem] {
        let mirror = Mirror(reflecting: self)
        let dictionary = mirror.toDictionary(type: Self.caseType)
        return dictionary.compactMapValues { String(describing: $0) }
            .map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    func toHttpBody() throws -> Data  {
        let mirror = Mirror(reflecting: self)
        let dictionary = mirror.toDictionary(type: Self.caseType)
        return try JSONSerialization.data(withJSONObject: dictionary, options: [])
    }
}
