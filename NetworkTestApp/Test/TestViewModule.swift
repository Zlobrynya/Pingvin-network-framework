//
//  TestViewModule.swift
//  NetworkTestApp
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import SwiftUI
import NetworkFramework

class Test: NetworkResultHandler {

    var requst: GetRequest?
    
    func testNetwork() {
        let url = URL(string: "https://rickandmortyapi.com/api/character")!
        let requst = GetRequest(url: url, session: URLSession.shared, resultHandler: self)
        requst?.send()
    }
    
    
    func requestSuccessfulWithResult(_ data: Data?) {
        debugPrint("❤️ requestSuccessfulWithResult")
    }
    
    func requestFaildWithError(_ error: ErrorRequest) {
        debugPrint("❤️ requestFaildWithError")
    }
}
