//
//  PostRequest.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import Foundation

public class PostRequest: RequestProtocol {
 
    // MARK: - Private properties
    
    private let request: URLRequest
    private var task: Task.Handle<Data, Error>?

    // MARK: - External Dependencies

    private let session: URLSessionProtocol

    // MARK: - Lifecycle

    public init<Parameters: RequestParametersProtocol>(
        url: URL,
        session: URLSessionProtocol,
        bodyParameters: Parameters? = nil,
        queryParameters: Parameters? = nil,
        headers: Headers? = nil,
        encoder: JSONEncoder = JSONEncoder()
    ) throws {
        self.session = session
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else { throw NetworkingError.wrongUrl }

        if let parameters = queryParameters {
            urlComponents.queryItems = parameters.toQueryItem()
        }

        guard let url = urlComponents.url else { throw NetworkingError.wrongUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        if let parameters = bodyParameters {
            request.httpBody = try encoder.encode(parameters)
        }
            
        headers?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        self.request = request
    }

    // MARK: - Public functions

    public func send() async throws -> Data {
        task = async { () -> Data in
            try await session.data(for: request)
        }
        guard let task = task else { throw NetworkingError.emptyResponse }
        return try await task.get()
    }
    
    public func cancel() {
        task?.cancel()
    }
}
