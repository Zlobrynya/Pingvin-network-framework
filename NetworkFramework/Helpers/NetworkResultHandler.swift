import Foundation

public protocol NetworkResultHandler: AnyObject {
    func requestSuccessfulWithResult(_ data: Data?)
    func requestFaildWithError(_ error: NetworkingError)
}
