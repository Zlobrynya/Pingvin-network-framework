//
//  RequestProtocol.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 03.04.2021.
//

import Foundation

public protocol RequestProtocol {
    ///  <#Description#>
    ///
    /// - Parameter <#Name Parameter#>: <#Parameter Description#>
    func send()
    
    func cancel()
}

public typealias Headers = [String: String]

