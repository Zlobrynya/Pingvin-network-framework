import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> Data
    func data(for request: URLRequest) async throws -> Data
}

extension URLSession: URLSessionProtocol {
    public func data(for request: URLRequest, delegate: URLSessionTaskDelegate? = nil) async throws -> Data {
        let (data, response) = try await data(for: request, delegate: delegate)
        guard let info = response as? HTTPURLResponse else { throw NetworkingError.emptyResponse }
        switch info.statusCode {
        case 200 ... 226:
            return data
        case 300 ... 520:
            guard let status = HTTPStatusCode(rawValue: info.statusCode) else { throw NetworkingError.emptyResponse }
            throw NetworkingError.httpError(with: status)
        default:
            throw NetworkingError.somethingHappened
        }
    }
    
    public func data(for request: URLRequest) async throws -> Data {
        try await data(for: request, delegate: nil)
    }
}
