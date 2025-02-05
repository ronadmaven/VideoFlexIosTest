//
//  IsSubscribedEnvKey.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 06/07/2024.
//

import Foundation

import SwiftUI

private struct IsSubscribedEnvKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var isSubscribed: Bool {
        get { self[IsSubscribedEnvKey.self] }
        set { self[IsSubscribedEnvKey.self] = newValue }
    }
}
