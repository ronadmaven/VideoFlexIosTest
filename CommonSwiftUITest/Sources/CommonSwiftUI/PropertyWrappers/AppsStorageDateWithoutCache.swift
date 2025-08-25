//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 16/07/2025.
//

import SwiftUI

@propertyWrapper
public struct AppsStorageDateWithOutCache {
    private let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Date? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            return dataToDate(data)
        }
        set {
            if let newValue {
                let data = dateToData(newValue)
                UserDefaults.standard.setValue(data, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key) // Remove if nil
            }
        }
    }

    // MARK: private

    private func dateToData(_ date: Date) -> Data {
        let timeInterval = date.timeIntervalSince1970
        return withUnsafeBytes(of: timeInterval) { Data($0) }
    }

    private func dataToDate(_ data: Data) -> Date? {
        let timeInterval = data.withUnsafeBytes {
            $0.load(as: TimeInterval.self)
        }
        return Date(timeIntervalSince1970: timeInterval)
    }
}
