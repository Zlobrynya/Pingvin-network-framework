//
//  NetworkRequestFactory.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.04.2021.
//

import Foundation

public protocol NetworkRequestFactoryProtocol {
    func get<T: RequestParametersProtocol>(
        url: URL,
        parameters: T,
        resultHandler: NetworkResultHandler?
    ) -> RequestProtocol?

    func post<T: RequestParametersProtocol>(
        url: URL,
        parameters: T,
        resultHandler: NetworkResultHandler?
    ) -> RequestProtocol?
}

public extension NetworkRequestFactoryProtocol {
    func get(url: URL, resultHandler: NetworkResultHandler?) -> RequestProtocol? {
        get(url: url, parameters: EmptyRequestParameters(), resultHandler: resultHandler)
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
        resultHandler: NetworkResultHandler?
    ) -> RequestProtocol? {
        return GetRequest(
            url: url,
            session: session,
            parameters: parameters,
            resultHandler: resultHandler
        )
    }

    //TODO
    public func post<T: RequestParametersProtocol>(
        url: URL,
        parameters: T,
        resultHandler: NetworkResultHandler?
    ) -> RequestProtocol? {
        return nil
    }
}
