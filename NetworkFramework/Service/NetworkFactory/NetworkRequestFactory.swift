//
//  NetworkRequestFactory.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.04.2021.
//

import Foundation

public protocol NetworkRequestFactoryProtocol {
    func get<T: RequestParametersProtocol>(url: URL, parameters: T?, headers: Headers?) throws -> RequestProtocol

    func post<BParameters: RequestParametersProtocol, QParameters: RequestParametersProtocol>(
        url: URL,
        withBodyParameters bodyParameters: BParameters?,
        withQueryParameters queryParameters: QParameters?,
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

    public func post<BParameters: RequestParametersProtocol, QParameters: RequestParametersProtocol>(
        url: URL,
        withBodyParameters bodyParameters: BParameters?,
        withQueryParameters queryParameters: QParameters?,
        andHeaders headers: Headers?
    ) throws -> RequestProtocol {
        try PostRequest(
            url: url,
            session: session,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            headers: headers
        )
    }
}
