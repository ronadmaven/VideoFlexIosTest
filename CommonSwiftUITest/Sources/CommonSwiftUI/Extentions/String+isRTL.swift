//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 11/12/2024.
//

import Foundation

import NaturalLanguage

public extension String {
    var isRTL: Bool {
        guard let language = NLLanguageRecognizer.dominantLanguage(for: self) else { return false }
        switch language {
        case .arabic, .hebrew, .persian, .urdu:
            return true
        default:
            return false
        }
    }
}
