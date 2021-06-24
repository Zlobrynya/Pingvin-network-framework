import Foundation

public enum NetworkingError: LocalizedError {
    case httpError(with: HTTPStatusCode)
    case emptyResponse
    // TODO: Rename
    case somethingHappened
}
