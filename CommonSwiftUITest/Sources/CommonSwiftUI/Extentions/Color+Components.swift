//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 06/09/2024.
//

import SwiftUI
import UIKit

public extension Color {
    var components: [CGFloat]? {
        cgColor?.components
    }

    mutating func from(components: [CGFloat]) {
        guard components.count == 4 else { return }
        let cgColor: CGColor = .init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        self = Color(cgColor: cgColor)
    }

    init(components: [CGFloat]) {
        let cgColor: CGColor = .init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        self = Color(cgColor: cgColor)
    }
}
