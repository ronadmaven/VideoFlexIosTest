//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 30/12/2024.
//

import Foundation

public extension String {
    var toCamelCaps: String {
        let components = split(separator: "_")
        let camelCase = components.enumerated().map { index, word in
            index == 0 ? word.lowercased() : word.capitalized
        }.joined()
        return camelCase
    }
}
