//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 13/10/2024.
//

import Foundation

public extension String {
    var toSnakeCaps: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)

        let snakeCase = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2")
        return snakeCase.lowercased()
    }
}
