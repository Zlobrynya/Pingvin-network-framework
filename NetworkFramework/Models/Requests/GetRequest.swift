//
//  GetRequest.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import Foundation

import Foundation

public protocol RequestParametersProtocol {}

public struct GetRequest: RequestProtocol {

    // MARK: - Private properties

    private let request: URLRequest

    // MARK: - External Dependencies

    private let session: URLSessionProtocol
    private let resultHandler: NetworkResultHandler

    // MARK: - Lifecycle

    init?(url: URL, session: URLSessionProtocol, parameters: RequestParametersProtocol,) {
        self.session = session
        let request = URLRequest(url: url)
        self.request = request
    }

    // MARK: - Public functions

    public func send() {
        session.dataTask(
            with: request,
            completionHandler: { data, _, error in
                if let error = error {
                    resultHandler.requestFaildWithError(error)
                } else {
                    resultHandler.requestSuccessfulWithResult(data)
                }
            }
        )
    }
}
