
//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 21/10/2024.
//

import SwiftUI

@propertyWrapper
public struct KeychainStorage<Value: Codable>: DynamicProperty {
    private let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Value? {
        get {
            guard let data = KeyChainUtil.getData(forKey: key) else {
                return nil
            }

            return try? JSONDecoder().decode(Value.self, from: data)
        }
        set {
            if let newValue, let data = try? JSONEncoder().encode(newValue) {
                KeyChainUtil.set(data: data, forKey: key)
            } else {
                KeyChainUtil.deleteFromKeychain(forKey: key)
            }
        }
    }
}
