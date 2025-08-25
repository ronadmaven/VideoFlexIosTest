//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 21/10/2024.
//

import SwiftUI

@propertyWrapper
public struct AppsStorageDate: DynamicProperty {
    // Static cache to share values across instances with same key
    private static var cache: [String: Date?] = [:]
    private static let lock = NSLock()

    @State private var updateTrigger = 0
    private let key: String

    public init(_ key: String) {
        self.key = key
        // Initialize cache if this key hasn't been cached yet
        Self.lock.lock()
        defer { Self.lock.unlock() }
        Self.cache[key] = Self.cache[key] ?? Self.loadDate(forKey: key)
    }

    public var wrappedValue: Date? {
        get {
            Self.lock.lock()
            defer { Self.lock.unlock() }
            return Self.cache[key] ?? nil
        }
        nonmutating set {
            // Update the static cache first
            Self.lock.lock()
            let oldValue = Self.cache[key]
            Self.cache[key] = newValue
            Self.lock.unlock()

            // Update UserDefaults
            if let date = newValue {
                let data = Self.dateToData(date)
                UserDefaults.standard.set(data, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }

            // Trigger view update if value actually changed
            if oldValue != newValue {
                updateTrigger += 1
            }
        }
    }

    // MARK: Helpers

    private static func loadDate(forKey key: String) -> Date? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        let interval = data.withUnsafeBytes { $0.load(as: TimeInterval.self) }
        return Date(timeIntervalSince1970: interval)
    }

    private static func dateToData(_ date: Date) -> Data {
        let timeInterval = date.timeIntervalSince1970
        return withUnsafeBytes(of: timeInterval) { Data($0) }
    }
}
