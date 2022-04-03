//
//  EmptyParameters.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 18.07.2021.
//

import Foundation

struct EmptyParameters: RequestParametersProtocol {
    static var caseType: CaseTypes { .camelCase }
}
