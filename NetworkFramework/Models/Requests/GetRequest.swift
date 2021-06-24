//
//  GetRequest.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public class GetRequest: RequestProtocol {

    // MARK: - Private properties
    
    private let request: URLRequest
    private var task: Task.Handle<Data, Error>?

    // MARK: - External Dependencies

    private let session: URLSessionProtocol
    private var resultHandler: NetworkResultHandler?

    // MARK: - Lifecycle

    public init?<Parameters: RequestParametersProtocol>(
        url: URL,
        session: URLSessionProtocol,
        parameters: Parameters? = nil,
        headers: Headers? = nil,
        resultHandler: NetworkResultHandler? = nil,
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.resultHandler = resultHandler
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.toQueryItem(with: encoder)
        }
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.rawValue
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        self.request = request
    }

    // MARK: - Public functions

    //line by line https://developer.apple.com/videos/play/wwdc2021/10095/
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
