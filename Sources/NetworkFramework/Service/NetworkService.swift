//
//  NetworkService.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 29.06.2021.
//

import Foundation

// MARK: - NetworkServiceProtocol

public protocol NetworkServiceProtocol {
    func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> T?

    func get<Parameters: RequestParametersProtocol>(
        forUrl url: URL,
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> Data?

    func post<T: Decodable, B: RequestParametersProtocol, Q: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        withQueryParameters queryParameters: Q,
        andHeaders headers: Headers?
    ) async throws -> T?

    func post<B: RequestParametersProtocol, Q: RequestParametersProtocol>(
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        withQueryParameters queryParameters: Q,
        andHeaders headers: Headers?
    ) async throws -> Data?
}

// MARK: - Extension NetworkServiceProtocol

public extension NetworkServiceProtocol {

    func get<T: Decodable>(
        forModel model: T.Type,
        forUrl url: URL,
        andHeaders headers: Headers? = nil
    ) async throws -> T? {
        try await get(forModel: model, forUrl: url, withParameters: EmptyParameters(), andHeaders: headers)
    }

    func get(forUrl url: URL, andHeaders headers: Headers? = nil) async throws -> Data? {
        try await get(forUrl: url, withParameters: EmptyParameters(), andHeaders: headers)
    }

    func post<T: Decodable, Q: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withQueryParameters parameters: Q,
        andHeaders headers: Headers? = nil
    ) async throws -> T? {
        try await post(
            forModel: model,
            forUrl: url,
            withBodyParameters: EmptyParameters(),
            withQueryParameters: parameters,
            andHeaders: headers
        )
    }

    func post<T: Decodable, B: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        andHeaders headers: Headers? = nil
    ) async throws -> T? {
        try await post(
            forModel: model,
            forUrl: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: EmptyParameters(),
            andHeaders: headers
        )
    }

    func post<B: RequestParametersProtocol>(
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        andHeaders headers: Headers?
    ) async throws -> Data? {
        try await post(
            forUrl: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: EmptyParameters(),
            andHeaders: headers
        )
    }

    func post<Q: RequestParametersProtocol>(
        forUrl url: URL,
        withQueryParameters queryParameters: Q,
        andHeaders headers: Headers?
    ) async throws -> Data? {
        try await post(
            forUrl: url,
            withBodyParameters: EmptyParameters(),
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
    }
}

// MARK: - NetworkService

public struct NetworkService: NetworkServiceProtocol {

    // MARK: - External Dependencies

    private let networkFactory: NetworkRequestFactoryProtocol
    private let jsonDecoder: JSONDecoder

    // MARK: - Lifecycle

    public init(
        networkFactory: NetworkRequestFactoryProtocol = NetworkRequestFactory(),
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) {
        self.networkFactory = networkFactory
        self.jsonDecoder = jsonDecoder
    }

    // MARK: - Public functions

    public func get<T, Parameters>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> T? where T: Decodable, Parameters: RequestParametersProtocol {
        guard let data = try await get(forUrl: url, withParameters: parameters, andHeaders: headers)
        else { throw NetworkingError.wrongUrl }
        return try jsonDecoder.decode(model, from: data)
    }

    public func get<Parameters>(
        forUrl url: URL,
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> Data? where Parameters: RequestParametersProtocol {
        let request = try networkFactory.get(url: url, parameters: parameters, headers: headers)
        return try await request.send()
    }

    public func post<T, B, Q>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        withQueryParameters queryParameters: Q,
        andHeaders headers: Headers?
    ) async throws -> T? where T: Decodable, B: RequestParametersProtocol, Q: RequestParametersProtocol {
        guard let data = try await post(
            forUrl: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
        else { throw NetworkingError.somethingHappened }
        return try jsonDecoder.decode(model, from: data)
    }

    public func post<B, Q>(
        forUrl url: URL,
        withBodyParameters bodyParameters: B,
        withQueryParameters queryParameters: Q,
        andHeaders headers: Headers?
    ) async throws -> Data? where B: RequestParametersProtocol, Q: RequestParametersProtocol {
        let request = try networkFactory.post(
            url: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
        return try await request.send()
    }
}
