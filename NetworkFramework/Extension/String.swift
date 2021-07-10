//
//  String.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 10.07.2021.
//

import Foundation

extension String {
    func formatForCaseType(_ caseType: CaseTypes) -> Self {
        guard caseType != .camelCase else { return self }
        let newString = splitBefore { $0.isUppercase }
            .map { String($0).lowercased() }
            .joined(separator: caseType.rawValue)
            
        return newString
    }
}
