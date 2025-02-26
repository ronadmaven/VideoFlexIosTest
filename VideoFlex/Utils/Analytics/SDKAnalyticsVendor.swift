//
//  MixpanelAnalytics.swift
//  SoLoyal
//
//  Created by SoLoyal.co on 29/09/2019.
//  Copyright © 2019 SoLoyal. All rights reserved.
//

import SDK
class SDKAnalyticsVendor: AnalyticsVendor {
    private var sdk: TheSDK
    private(set) var name = "sdk"

    init(sdk: TheSDK) {
        self.sdk = sdk
    }

    func send(event: AnalyticEventProtocol, subVendor: String? = nil) {
        print("⭐️⭐️ Analytics: \(event.name) - \(String(describing: event.parameters))")
        // TODO:
        // sdk.sendPixelEvent(name: event.name, payload: event.parameters)
    }

    func identify(id: String?, subVendor: String? = nil) {
    }

    func setUser(properties: [AnalyticsUserProperty], subVendor: String?) {}
}
