//
//  File.swift
//  SDK
//
//  Created by Dubon Ya'ar on 05/06/2025.
//

import Foundation
import SwiftUI

public enum SDKStore {
    static var userId: String = "dummy"
    static var firstInstallTime: String?
    static var lastInstallTime: String?
    public static var sessionId: String = "dummy-session-id"

    public static var numberOfInstalls: Int = 1

    public static func purge() {}
}
