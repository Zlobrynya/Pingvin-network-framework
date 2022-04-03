//
//  Response.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 11.04.2021.
//

import Foundation

public protocol ResponseProtocol {
    var data: Data? { get }
}

public struct Response: ResponseProtocol {
    public let data: Data?
}
