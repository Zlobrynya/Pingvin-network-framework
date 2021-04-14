import Foundation

public protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        errorHandler: @escaping (ErrorRequest) -> Void,
        resultHandler: @escaping (Data?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {

    public func dataTask(
        with request: URLRequest,
        errorHandler: @escaping (ErrorRequest) -> Void,
        resultHandler: @escaping (Data?) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { data, response, error in
            if let error = error {
                errorHandler(ErrorRequest.error(error))
            } else {
                guard let info = response as? HTTPURLResponse else {
                    errorHandler(.emptyResponse)
                    return
                }
                switch info.statusCode {
                case 200 ... 226:
                    resultHandler(data)
                case 300 ... 520:
                    guard let status = HTTPStatusCode(rawValue: info.statusCode) else {
                        errorHandler(.emptyResponse)
                        return
                    }
                    errorHandler(ErrorRequest.httpError(with: status))
                default:
                    errorHandler(.emptyResponse)
                }
            }
        }
    }
}
