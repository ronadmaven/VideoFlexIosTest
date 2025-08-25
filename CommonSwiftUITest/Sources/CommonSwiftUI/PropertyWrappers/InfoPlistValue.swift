//
//  Temp.swift
//  Scanner
//
//  Created by Dubon Ya'ar on 30/11/2024.
//

import SwiftUI

@propertyWrapper public struct InfoPlistOptionalValue<T> {
    var key: String

    public init(key: String) {
        self.key = key
    }

    public var wrappedValue: T? {
        get {
            Bundle.main.infoDictionary?[key] as? T
        }
        set {}
    }
}

@propertyWrapper public struct InfoPlistValue<T> {
    var defaultValue: T
    var key: String

    public init(wrappedValue defaultValue: T, key: String) {
        self.defaultValue = defaultValue
        self.key = key
    }

    public var wrappedValue: T {
        get {
            Bundle.main.infoDictionary?[key] as? T ?? defaultValue
        }
        set {}
    }
}
