//
//  NetworkService.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 29.06.2021.
//

import Foundation

// MARK: - NetworkServiceProtocol

public protocol NetworkServiceProtocol {
    
    typealias Parameters = RequestParametersProtocol

    func request<Responce: Decodable, QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?,
        responceType: Responce.Type
    ) async throws -> Responce

    func request<QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?
    ) async throws -> Data
}

// MARK: - Extension NetworkServiceProtocol

public extension NetworkServiceProtocol {

    func request<Responce: Decodable, QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers? = nil,
        responceType: Responce.Type
    ) async throws -> Responce {
        try await request(
            url,
            method: method,
            queryParameters: EmptyParameters(),
            bodyParameters: bodyParameters,
            headers: headers,
            responceType: responceType
        )
    }

    func request<Responce: Decodable, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        bodyParameters: BodyParameters,
        headers: Headers? = nil,
        responceType: Responce.Type
    ) async throws -> Responce {
        try await request(
            url,
            method: method,
            queryParameters: EmptyParameters(),
            bodyParameters: bodyParameters,
            headers: headers,
            responceType: responceType
        )
    }

    func request<Responce: Decodable, QueryParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        headers: Headers? = nil,
        responceType: Responce.Type
    ) async throws -> Responce {
        try await request(
            url,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: EmptyParameters(),
            headers: headers,
            responceType: responceType
        )
    }

    func request<Responce: Decodable>(
        _ url: String,
        method: RequestType,
        headers: Headers? = nil,
        responceType: Responce.Type
    ) async throws -> Responce {
        try await request(
            url,
            method: method,
            queryParameters: EmptyParameters(),
            bodyParameters: EmptyParameters(),
            headers: headers,
            responceType: responceType
        )
    }

    func request<QueryParameters: Parameters, BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers? = nil
    ) async throws -> Data {
        try await request(
            url,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            headers: headers
        )
    }

    func request<QueryParameters: Parameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        headers: Headers? = nil
    ) async throws -> Data {
        try await request(
            url,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: EmptyParameters(),
            headers: headers
        )
    }

    func request<BodyParameters: Parameters>(
        _ url: String,
        method: RequestType,
        bodyParameters: BodyParameters,
        headers: Headers? = nil
    ) async throws -> Data {
        try await request(
            url,
            method: method,
            queryParameters: EmptyParameters(),
            bodyParameters: bodyParameters,
            headers: headers
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

    public func request<QueryParameters, BodyParameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?
    ) async throws -> Data where QueryParameters: Parameters, BodyParameters: Parameters {
        let request = try networkFactory.request(
            url,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            headers: headers
        )
        return try await request.send()
    }

    public func request<Responce, QueryParameters, BodyParameters>(
        _ url: String,
        method: RequestType,
        queryParameters: QueryParameters,
        bodyParameters: BodyParameters,
        headers: Headers?,
        responceType: Responce.Type
    ) async throws -> Responce where Responce: Decodable, QueryParameters: Parameters, BodyParameters: Parameters {
        let data = try await request(
            url,
            method: method,
            queryParameters: queryParameters,
            bodyParameters: bodyParameters,
            headers: headers
        )
        return try jsonDecoder.decode(responceType, from: data)
    }

//    public func get<T, Parameters>(
//        forModel model: T.Type,
//        forUrl url: URL,
//        withParameters parameters: Parameters,
//        andHeaders headers: Headers?
//    ) async throws -> T? where T: Decodable, Parameters: Parameters {
//        guard let data = try await get(forUrl: url, withParameters: parameters, andHeaders: headers)
//        else { throw NetworkingError.wrongUrl }
//        return try jsonDecoder.decode(model, from: data)
//    }
//
//    public func get<Parameters>(
//        forUrl url: URL,
//        withParameters parameters: Parameters,
//        andHeaders headers: Headers?
//    ) async throws -> Data? where Parameters: Parameters {
//        let request = try networkFactory.get(url: url, parameters: parameters, headers: headers)
//        return try await request.send()
//    }
//
//    public func post<T, B, Q>(
//        forModel model: T.Type,
//        forUrl url: URL,
//        withBodyParameters bodyParameters: B,
//        withQueryParameters queryParameters: Q,
//        andHeaders headers: Headers?
//    ) async throws -> T? where T: Decodable, B: Parameters, Q: Parameters {
//        guard let data = try await post(
//            forUrl: url,
//            withBodyParameters: bodyParameters,
//            withQueryParameters: queryParameters,
//            andHeaders: headers
//        )
//        else { throw NetworkingError.somethingHappened }
//        return try jsonDecoder.decode(model, from: data)
//    }
//
//    public func post<B, Q>(
//        forUrl url: URL,
//        withBodyParameters bodyParameters: B,
//        withQueryParameters queryParameters: Q,
//        andHeaders headers: Headers?
//    ) async throws -> Data? where B: Parameters, Q: Parameters {
//        let request = try networkFactory.post(
//            url: url,
//            withBodyParameters: bodyParameters,
//            withQueryParameters: queryParameters,
//            andHeaders: headers
//        )
//        return try await request.send()
//    }
}
