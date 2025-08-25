//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 07/08/2024.
//

import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    public static var defaultValue: CGSize = .zero
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
