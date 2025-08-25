//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 11/11/2024.
//

import SwiftUI

@propertyWrapper
public struct AppsStorageColor {
    private let key: String

    public init(_ key: String) {
        self.key = key
    }

    public var wrappedValue: Color? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
            guard let json = try? JSONSerialization.jsonObject(with: data) as? [CGFloat] else { return nil }
            return Color(_components: json)
        }
        set {
            guard let newValue else {
                UserDefaults.standard.removeObject(forKey: key)
                return
            }

            guard let components = newValue._components, let data = try? JSONSerialization.data(withJSONObject: components) else { return }

            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

// ourRateAppResponse
private extension Color {
    var _components: [CGFloat]? {
        UIColor(self).cgColor.components
    }

    mutating func _from(components: [CGFloat]) {
        guard components.count == 4 else { return }
        let cgColor: CGColor = .init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        self = Color(cgColor: cgColor)
    }

    init(_components components: [CGFloat]) {
        let cgColor: CGColor = .init(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        self = Color(cgColor: cgColor)
    }
}
