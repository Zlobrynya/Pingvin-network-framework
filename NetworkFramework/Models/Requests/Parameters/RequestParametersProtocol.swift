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
}

public protocol RequestParametersProtocol: Encodable {
    static var caseType: CaseTypes { get }
}

extension RequestParametersProtocol {
    func test() {
        let mirror = Mirror(reflecting: self)
        mirror.toQueryItem(type: Self.caseType)
    }
}
