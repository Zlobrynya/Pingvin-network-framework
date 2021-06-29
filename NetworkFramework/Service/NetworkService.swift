//
//  NetworkService.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 29.06.2021.
//

import Foundation

public protocol NetworkServiceProtocol {

    func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> T?
}

public extension NetworkServiceProtocol {

    func get<T: Decodable, Parameters: RequestParametersProtocol>(
        forModel model: T.Type,
        forUrl url: URL,
        withParameters parameters: Parameters
    ) async throws -> T? {
        try await get(forModel: model, forUrl: url, withParameters: parameters, andHeaders: nil)
    }

    func get<T: Decodable>(forModel model: T.Type,forUrl url: URL) async throws -> T?{
        try await get(forModel: model, forUrl: url, withParameters: EmptyRequestParameters(), andHeaders: nil)
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
        withParameters parameters: Parameters,
        andHeaders headers: Headers?
    ) async throws -> T? {
        let request = try networkFactory.get(url: url, parameters: parameters, headers: headers)
        let data = try await request.send()
        let object = try jsonDecoder.decode(model, from: data)
        return object
    }
}
