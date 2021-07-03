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
    
    func post<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters parameters: Parameters?,
        withQueryParameters parameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T?
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
        let request = try networkFactory.get(url: url, parameters: parameters, headers: headers)
        let data = try await request.send()
        let object = try jsonDecoder.decode(model, from: data)
        return object
    }
    
    public func post<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withBodyParameters bodyParameters: Parameters?,
        withQueryParameters queryParameters: Parameters?,
        andHeaders headers: Headers?
    ) async throws -> T? {
        let request = try networkFactory.post(
            url: url,
            withBodyParameters: bodyParameters,
            withQueryParameters: queryParameters,
            andHeaders: headers
        )
        let data = try await request.send()
        let object = try jsonDecoder.decode(model, from: data)
        return object
    }
 
}
