//
//  NetworkRequestFactory.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.04.2021.
//

import Foundation

public protocol NetworkRequestFactoryProtocol {
    func get<T: RequestParametersProtocol>(url: URL, parameters: T?, headers: Headers?) throws -> RequestProtocol

    func post<T: RequestParametersProtocol>(
        url: URL,
        withBodyParameters bodyParameters: T?,
        withQueryParameters queryParameters: T?,
        andHeaders headers: Headers?
    ) throws -> RequestProtocol
}


public struct NetworkRequestFactory: NetworkRequestFactoryProtocol {

    // MARK: - External Dependencies

    private let session: URLSessionProtocol

    // MARK: - Lifecycle

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Public functions

    public func get<T: RequestParametersProtocol>(
        url: URL,
        parameters: T?,
        headers: Headers?
    ) throws -> RequestProtocol {
        try GetRequest(
            url: url,
            session: session,
            parameters: parameters,
            headers: headers
        )
    }

    public func post<T: RequestParametersProtocol>(
        url: URL,
        withBodyParameters bodyParameters: T?,
        withQueryParameters queryParameters: T?,
        andHeaders headers: Headers?
    ) throws -> RequestProtocol {
        try PostRequest(
            url: url,
            session: session,
            bodyParameters: bodyParameters,
            queryParameters: queryParameters,
            headers: headers
        )
    }
}
