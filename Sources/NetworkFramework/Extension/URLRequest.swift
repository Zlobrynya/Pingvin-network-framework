//
//  URLRequest.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2022.
//

import Foundation

extension URLRequest {

    /// Return `RequestType` of request.
    var method: RequestType? {
        get {
            guard let httpMethod = httpMethod else { return nil }
            return RequestType(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}
