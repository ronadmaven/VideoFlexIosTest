//
//  SentryEvents.swift
//  Snappers
//
//  Created by Alon Genosar on 24/04/2018.
//  Copyright © 2018 Alon Genosar All rights reserved.
//

import UIKit

public class A: AnalyticsGroupVendor {
    var defaultVendorGroup: String = "default"
    public static let s: A = .init(name: "analytics")
}
