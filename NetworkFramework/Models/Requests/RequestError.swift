//
//  RequestError.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 29.06.2021.
//

import Foundation

enum RequestError: LocalizedError {
    case wrongUrl
    
    var errorDescription: String? {
        switch self {
        case .wrongUrl: return "Error when creating URL"
        }
    }
}
