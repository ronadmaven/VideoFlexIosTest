//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 13/11/2024.
//

import Foundation

public enum CommonError: Error, Equatable {
    case generic, reason(String), http(code: Int, reason: String?)

    public var localizedDescription: String {
        switch self {
        case .generic:
            return "An unexpected error occurred"
        case let .reason(message):
            return message
        case let .http(code, reason):
            if let reason = reason {
                return "HTTP Error \(code): \(reason)"
            } else {
                return "HTTP Error \(code)"
            }
        }
    }

    public var description: String {
        localizedDescription
    }
}
