//
//  RequestParametersProtocol.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 20.05.2021.
//

import Foundation

public enum CaseTypes: Encodable {
    case camelCase
    case snakeCase
    case kebabCase

    var rawValue: String {
        switch self {
        case .camelCase: return ""
        case .snakeCase: return "_"
        case .kebabCase: return "-"
        }
    }
}

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
    
    func toBody() -> Data? {
        let mirror = Mirror(reflecting: self)
        let dictionary = mirror.toDictionary(type: Self.caseType)
        return try? JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
    }
}
