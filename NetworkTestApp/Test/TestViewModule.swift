//
//  TestViewModule.swift
//  NetworkTestApp
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import NetworkFramework
import SwiftUI

class Test {

    var requst: Request?
    let network: NetworkRequestFactoryProtocol = NetworkRequestFactory()

    func testNetwork() {
        let mock = MockParameter()
        let url = "https://animechan.vercel.app/api/quotes/anime"
        let headers = ["Content-Type": "application/json"]
        let networkService: NetworkServiceProtocol = NetworkService()
        Task {
            do {
                let obj = try await networkService.request(url, method: .get, headers: headers, responceType: [Response].self)
                debugPrint("❤️ obj \(obj)")
            } catch {
                debugPrint("❤️ error \(error)")
            }
        }

//        let requst = try? network.get(url: url, parameters: mock, headers: headers)
//        // GetRequest(url: url, session: URLSession.shared, resultHandler: self)
//        let data = try? await requst?.send()
//        debugPrint("❤️ data \(String(data: data ?? Data(), encoding: .utf8))")
    }
}

struct MockParameter: RequestParametersProtocol {
    static var caseType: CaseTypes = .kebabCase

    let title = "naruto"
    let keyTest = Test()

    struct Test: Encodable {
        let testIn = "testIn"
    }
}

struct Response: Decodable {
    let anime: String
    let character: String
    let quote: String
}
