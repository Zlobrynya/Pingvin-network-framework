import Foundation

public protocol NetworkResultHandler {
    func requestSuccessfulWithResult(_ data: Data?)
    func requestFaildWithError(_ error: ErrorRequest)
}
