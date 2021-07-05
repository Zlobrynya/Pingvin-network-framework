//
//  Mirror.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 05.07.2021.
//

import Foundation

extension Mirror {
    func toQueryItem(type: CaseTypes) -> [String: Any] {
        let test: [String: Any] = children.toDictionary { child in
            guard let label = child.label else { return nil }
            print("🔵 \(child.value)")
            
            return (label.formatForCaseType(type), "")
        }//.map { URLQueryItem(name: $0.key, value: $0.value as! String) }
//        return nil
        Optional("")
        return test
    }
}

extension String {
    func formatForCaseType(_ caseType: CaseTypes) -> Self {
        //
        return self
    }
}
