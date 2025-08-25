//
//  View+Print.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 14/07/2024.
//

import SwiftUI

public extension View {
    func debug(_ items: Any..., seperator: String = ",", terminator: String = "\n") -> some View {
        Swift.print(items, separator: seperator, terminator: terminator)
        return self
    }
}
