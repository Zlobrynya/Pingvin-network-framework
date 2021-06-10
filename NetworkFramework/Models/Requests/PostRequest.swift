//
//  PostRequest.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import Foundation

public struct PostRequest: RequestProtocol {

    // MARK: - Private properties
    
    private let request: URLRequest

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
        
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.post.rawValue
        if let parameters = parameters {
            request.httpBody = try? encoder.encode(parameters)
        }
            
        headers?.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        debugPrint("❤️ \(request.allHTTPHeaderFields)")
        self.request = request
    }

    // MARK: - Public functions

    public func send() {
        let resultHandler = self.resultHandler
        let task = session.dataTask(
            with: request,
            errorHandler: { resultHandler?.requestFaildWithError($0) },
            resultHandler: { resultHandler?.requestSuccessfulWithResult($0) }
        )
        task.resume()
    }
    
    public func cancel() {
        // TODO
    }
}
