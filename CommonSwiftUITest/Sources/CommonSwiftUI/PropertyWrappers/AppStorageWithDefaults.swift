//
//  SwiftUIView.swift
//  Climora
//
//  Created by Dubon Ya'ar on 30/06/2025.
//

import Combine
import SwiftUI

@propertyWrapper
public struct AppStorageWithDefaults<Value: Codable & Equatable>: DynamicProperty {
    private let key: String
    private let defaultValue: Value
    private let userDefaults: UserDefaults

    @State private var stateValue: Value

    public var wrappedValue: Value {
        get { stateValue }
        nonmutating set {
            stateValue = newValue
            saveToUserDefaults(newValue)
        }
    }

    public init(wrappedValue defaultValue: Value, _ key: String, userDefaults: UserDefaults) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults

        if let data = userDefaults.data(forKey: key),
           let value = try? JSONDecoder().decode(Value.self, from: data) {
            _stateValue = State(initialValue: value)
        } else if let primitive = userDefaults.object(forKey: key) as? Value {
            _stateValue = State(initialValue: primitive)
        } else {
            _stateValue = State(initialValue: defaultValue)
        }
    }

    private func saveToUserDefaults(_ newValue: Value) {
        if let data = try? JSONEncoder().encode(newValue) {
            userDefaults.set(data, forKey: key)
        } else {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
