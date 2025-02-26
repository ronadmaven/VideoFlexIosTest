//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 04/04/2023.
//

import Foundation

public enum AnalyticsEventLevel: String { case error, warning, info }
public enum AnalyticsUserProperty { case email(String), age(Int), gender(String), other(key: String, value: AnyHashable) }

public protocol AnalyticEventProtocol {
    var parameters: [String: Any]? { get }
    var name: String { get }
    var level: AnalyticsEventLevel { get }
}

public extension AnalyticEventProtocol {
    var level: AnalyticsEventLevel { .info }
    var name: String {
        let className = String(describing: Self.self)
        let range = NSRange(location: 0, length: className.utf8.count)
        let regex = try! NSRegularExpression(pattern: "([A-Z][a-z]*)")
        let results = regex.matches(in: className, range: range)
        let words = results.map { String(className[Range($0.range, in: className)!]) }
        return words.joined(separator: " ").capitalized
    }

    var parameters: [String: Any]? {
        return Mirror(reflecting: self).children.reduce(into: [:]) { dict, element in
            if let key = element.label {
                let value = element.value
                dict[key] = value
            }
        }
    }
}

public protocol AnalyticsVendor {
    var name: String { get }
    func send(event: AnalyticEventProtocol, subVendor: String?)
    func identify(id: String?, subVendor: String?)
    func setUser(properties: [AnalyticsUserProperty], subVendor: String?)
}
