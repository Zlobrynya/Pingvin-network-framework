//
//  Mirror.swift
//  NetworkFramework
//
//  Created by Nikita Nikitin on 05.07.2021.
//

import Foundation
import SwiftUI

extension Mirror {
    func toDictionary(type: CaseTypes) -> [String: Any] {
        children.toDictionary { child in
            guard let label = child.label else { return nil }
            return (label.formatForCaseType(type), child.value)
        }
    }
}

