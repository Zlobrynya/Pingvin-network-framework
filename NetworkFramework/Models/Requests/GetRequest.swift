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

public protocol RequestParametersProtocol: Encodable {}

public class GetRequest: RequestProtocol {

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
        
       
//        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let url = urlComponents.url else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = RequestType.get.rawValue
        
//        if let parameters = parameters {
//            request.queryItems
//        }
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
}
