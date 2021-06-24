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

    func testNetwork() async {
        let mock = MockParameter()
        let url = URL(string: "https://animechan.vercel.app/api/quotes/anime")!
        let headers = ["Content-Type": "application/json"]
        let requst = network.get(url: url, parameters: mock, headers: headers, resultHandler: self)
        /// GetRequest(url: url, session: URLSession.shared, resultHandler: self)
        let data = try? await requst?.send()
        debugPrint("❤️ data \(String(data: data ?? Data(), encoding: .utf8))")
//        requst?.cancel()
    }

    func requestSuccessfulWithResult(_ data: Data?) {
        guard let data = data else { return }
        debugPrint("❤️ requestSuccessfulWithResult \(String(data: data, encoding: .utf8))")
    }

    func requestFaildWithError(_ error: NetworkingError) {
        debugPrint("❤️ requestFaildWithError \(error)")
    }
}

struct MockParameter: RequestParametersProtocol {
    let title = "naruto"
}
