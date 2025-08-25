//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 13/11/2024.
//

import SwiftUI

extension Color: Codable {
    public func encode(to encoder: any Encoder) throws {
        guard let components = UIColor(self).cgColor.components else {
            throw CommonError.reason("couldnt get color components")
        }

        var container = encoder.unkeyedContainer()

        try container.encode(components[0])
        try container.encode(components[1])
        try container.encode(components[2])
        try container.encode(components[3])
    }

    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let red = try container.decodeIfPresent(Double.self)
        let green = try container.decodeIfPresent(Double.self)
        let blue = try container.decodeIfPresent(Double.self)
        let alpha = try container.decodeIfPresent(Double.self)

        guard let red, let green, let blue else {
            throw CommonError.reason("missing color components")
        }

        self = Color(red: red, green: green, blue: blue, opacity: alpha ?? 1)
    }
}
