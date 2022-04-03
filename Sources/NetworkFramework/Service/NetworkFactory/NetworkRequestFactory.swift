//
//  NetworkRequestFactory.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.04.2021.
//

import Foundation

public protocol NetworkRequestFactoryProtocol {
    typealias Parameters = RequestParametersProtocol

    func request<QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?
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

    public func request<QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?
    ) throws -> RequestProtocol {
        try Request(
            url: url,
            session: session,
            type: method,
            bodyParameters: bodyParameters,
            queryParameters: queryParameters,
            headers: headers
        )
    }
}
