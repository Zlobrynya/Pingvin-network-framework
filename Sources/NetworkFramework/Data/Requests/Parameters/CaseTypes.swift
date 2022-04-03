//
//  CaseTypes.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2022.
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
