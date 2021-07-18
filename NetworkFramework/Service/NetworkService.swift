//
//  NetworkService.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 29.06.2021.
//

import Foundation

public protocol NetworkServiceProtocol {
    func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T?

    func get<Parameters: RequestParametersProtocol>(
        forUrl url: URL,
        withParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> Data?

    func post<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters parameters: Parameters?,
        withQueryParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T?

    func post<Parameters: RequestParametersProtocol>(
        forUrl url: URL,
        withBodyParameters parameters: Parameters?,
        withQueryParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> Data?
}

public extension NetworkServiceProtocol {

    func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters? = nil,
        andHeaders headers: Headers? = nil
    ) async throws -> T? {
        try await get(forModel: model, forUrl: url, withParameters: parameters, andHeaders: headers)
    }

    func post<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: Parameters? = nil,
        withQueryParameters parameters: Parameters? = nil,
        andHeaders headers: Headers? = nil
    ) async throws -> T? {
        try await post(
            forModel: model,
            forUrl: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: parameters,
            andHeaders: headers
        )
    }
}

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

    public func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T? {
        guard let data = try await get(forUrl: url, withParameters: parameters, andHeaders: headers)
        else { throw NetworkingError.wrongUrl }
        return try jsonDecoder.decode(model, from: data)
    }

    public func post<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: Parameters?,
        withQueryParameters queryParameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T? {
        guard let data = try await post(
            forUrl: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
        else { throw NetworkingError.somethingHappened }
        return try jsonDecoder.decode(model, from: data)
    }

    public func get<Parameters: RequestParametersProtocol>(
        forUrl url: URL,
        withParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> Data? {
        let request = try networkFactory.get(url: url, parameters: parameters, headers: headers)
        return try await request.send()
    }

    public func post<Parameters: RequestParametersProtocol>(
        forUrl url: URL,
        withBodyParameters bodyParameters: Parameters?,
        withQueryParameters queryParameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> Data? {
        let request = try networkFactory.post(
            url: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
        return try await request.send()
    }
}
