//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 27/10/2024.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct AppsStorageCodable<T: Codable> {
    private let key: String
    private let container: UserDefaults

    public init(_ key: String, container: UserDefaults = .standard) {
        self.key = key
        self.container = container
    }

    public var wrappedValue: T? {
        get {
            guard let data = container.data(forKey: key) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }
        set {
            if let newValue {
                guard let data = try? JSONEncoder().encode(newValue) else { return }
                container.setValue(data, forKey: key)
            } else {
                container.removeObject(forKey: key) // Remove if nil
            }
        }
    }
}

@propertyWrapper
public struct AppsStorageCodableWithDefault<T: Codable> {
    private let key: String
    private let container: UserDefaults
    private let defaultValue: T

    public init(wrappedValue: T, _ key: String, container: UserDefaults = .standard) {
        self.key = key
        defaultValue = wrappedValue
        self.container = container
    }

    public var wrappedValue: T {
        get {
            guard let data = container.data(forKey: key) else { return defaultValue }
            do {
                let d = try JSONDecoder().decode(T.self, from: data)
                return d
            } catch {
                print("error decofing", error)
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                container.setValue(data, forKey: key)
            } catch {
                print("error encoding", error)
            }
        }
    }
}
