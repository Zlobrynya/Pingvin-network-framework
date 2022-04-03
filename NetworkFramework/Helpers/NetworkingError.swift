import Foundation

public enum NetworkingError: LocalizedError {
    case httpError(with: HTTPStatusCode)
    case emptyResponse
    case somethingHappened
    case wrongUrl

    public var errorDescription: String? {
        switch self {
        case let .httpError(error):
            return "Server error with status code: \(error.rawValue)"
        case .emptyResponse:
            return "Empty Response"
        case .somethingHappened:
            return "Something happened"
        case .wrongUrl:
            return "Wrong URL"
        }
    }
}
