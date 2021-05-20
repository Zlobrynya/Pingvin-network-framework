//
//  TestViewModule.swift
//  NetworkTestApp
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import NetworkFramework
import SwiftUI

class Test: NetworkResultHandler {

    var requst: GetRequest?
    let network: NetworkRequestFactoryProtocol = NetworkRequestFactory()

    func testNetwork() {
        let mock = MockParameter()
        let url = URL(string: "https://animechan.vercel.app/api/quotes/anime")!
        let headers = ["Content-Type": "application/json"]
        let requst = network.get(url: url, parameters: mock, headers: headers, resultHandler: self)
        /// GetRequest(url: url, session: URLSession.shared, resultHandler: self)
        requst?.send()
    }

    func requestSuccessfulWithResult(_ data: Data?) {
        guard let data = data else { return }
        debugPrint("❤️ requestSuccessfulWithResult \(String(data: data, encoding: .utf8))")
    }

    func requestFaildWithError(_ error: ErrorRequest) {
        debugPrint("❤️ requestFaildWithError \(error)")
    }
}

struct MockParameter: RequestParametersProtocol {
    let title = "naruto"
}
