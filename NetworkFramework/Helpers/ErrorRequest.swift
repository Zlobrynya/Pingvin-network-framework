import Foundation

public enum ErrorRequest {
    case httpError(with: HTTPStatusCode)
    case error(Error)
    case emptyResponse
}
