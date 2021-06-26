//
//  NetworkRequestFactory.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.04.2021.
//

import Foundation

public protocol NetworkRequestFactoryProtocol {
    func get<T: RequestParametersProtocol>(url: URL, parameters: T, headers: Headers?) -> RequestProtocol?

    func post<T: RequestParametersProtocol>(url: URL, parameters: T) -> RequestProtocol?
}

public extension NetworkRequestFactoryProtocol {
    func get<T: RequestParametersProtocol>(url: URL, parameters: T) -> RequestProtocol? {
        get(url: url, parameters: parameters, headers: nil)
    }

    func get(url: URL) -> RequestProtocol? {
        get(url: url, parameters: EmptyRequestParameters())
    }
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
        parameters: T,
        headers: Headers?
    ) -> RequestProtocol? {
        return GetRequest(
            url: url,
            session: session as! URLSession,
            parameters: parameters,
            headers: headers
        )
    }

    // TODO:
    public func post<T: RequestParametersProtocol>(
        url: URL,
        parameters: T
    ) -> RequestProtocol? {
        return nil
    }
}
