//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 04/04/2023.
//

// root

// dev    default
// a b      c  d

import Foundation

public class AnalyticsGroupVendor: AnalyticsVendor {
    public private(set) var name: String

    private var subVendors: [String: AnalyticsVendor] = [:]

    public init(name: String) {
        self.name = name
    }

    public func addSubVendor(_ vendor: AnalyticsVendor) {
        subVendors[vendor.name] = vendor
    }

    public func send(event: AnalyticEventProtocol, subVendor: String? = nil) {
        relevantVendors(subVendor: subVendor)?.forEach { $0.send(event: event, subVendor: subVendor) }
    }

    public func identify(id: String?, subVendor: String? = nil) {
        relevantVendors(subVendor: subVendor)?.forEach { $0.identify(id: id, subVendor: subVendor) }
    }

    public func setUser(properties: [AnalyticsUserProperty], subVendor: String? = nil) {
        relevantVendors(subVendor: subVendor)?.forEach { $0.setUser(properties: properties, subVendor: subVendor) }
    }

    public func relevantVendors(subVendor: String? = nil) -> [AnalyticsVendor]? {
        guard let subVendor = subVendor else {
            return subVendors.values.filter { type(of: $0) != AnalyticsGroupVendor.self }
        }

        guard let vendor = subVendors[subVendor] else {
            return nil
        }

        return [vendor]
    }
}
