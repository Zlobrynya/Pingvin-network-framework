//
//  Request.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2022.
//

import Foundation

public protocol RequestProtocol {
    ///  <#Description#>
    ///
    /// - Parameter <#Name Parameter#>: <#Parameter Description#>
    func send() async throws -> Data
    
    func cancel()
}

public typealias Headers = [String: String]

public class Request: RequestProtocol {

    // MARK: - Private properties

    private let request: URLRequest
    private var task: Task<Data, Error>?

    // MARK: - External Dependencies

    private let session: URLSessionProtocol

    // MARK: - Lifecycle

    public convenience init(
        url: String,
        session: URLSessionProtocol,
        type: RequestType,
        headers: Headers? = nil
    ) throws {
        try self.init(
            url: url,
            session: session,
            type: type,
            bodyParameters: EmptyParameters(),
            queryParameters: EmptyParameters(),
            headers: headers
        )
    }
    
    public convenience init<BodyParameters: RequestParametersProtocol>(
        url: String,
        session: URLSessionProtocol,
        type: RequestType,
        bodyParameters: BodyParameters,
        headers: Headers? = nil
    ) throws {
        try self.init(
            url: url,
            session: session,
            type: type,
            bodyParameters: bodyParameters,
            queryParameters: EmptyParameters(),
            headers: headers
        )
    }
    
    public convenience init<QueryParameters: RequestParametersProtocol>(
        url: String,
        session: URLSessionProtocol,
        type: RequestType,
        queryParameters: QueryParameters,
        headers: Headers? = nil
    ) throws {
        try self.init(
            url: url,
            session: session,
            type: type,
            bodyParameters: EmptyParameters(),
            queryParameters: queryParameters,
            headers: headers
        )
    }

    public init<BodyParameters: RequestParametersProtocol, QueryParameters: RequestParametersProtocol>(
        url: String,
        session: URLSessionProtocol,
        type: RequestType,
        bodyParameters: BodyParameters,
        queryParameters: QueryParameters,
        headers: Headers? = nil
    ) throws {
        self.session = session
        guard
            let url = URL(string: url),
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { throw NetworkingError.wrongUrl }

        if !(queryParameters is EmptyParameters) {
            urlComponents.queryItems = queryParameters.toQueryItem()
        }

        guard let url = urlComponents.url else { throw NetworkingError.wrongUrl }

        var request = URLRequest(url: url)
        
        if !(bodyParameters is EmptyParameters) {
            request.httpBody = try bodyParameters.toHttpBody()
        }
        
        request.method = type
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        self.request = request
    }

    // MARK: - Public functions

    public func send() async throws -> Data {
        task = Task { () -> Data in
            try await session.data(for: request)
        }
        guard let task = task else { throw NetworkingError.emptyResponse }
        return try await task.value
    }

    public func cancel() {
        task?.cancel()
    }
}
