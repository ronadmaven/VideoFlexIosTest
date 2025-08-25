//
//  Types.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 16/07/2024.
//

import AppTrackingTransparency
import Combine
import Foundation
import SwiftUI

public struct JSEventWrapper {
    var id: String
    var name: String
    var parameters: [String: Any]
    var error: String?

    public init(id: String, name: String, parameters: [String: Any], error: String? = nil) {
        self.id = id
        self.name = name
        self.parameters = parameters
        self.error = error
    }
}

public enum HTTPMethod: String { case get, put, post, delete }

public enum SDKError: Error { case generic, withReason(String) }

enum StoreKeys: String { case userId = "__userId__",
                              cid = "__cid__",
                              fistInsntallTime = "__fistIsntallTime__",
                              installTime = "__installTime__",
                              firstRun = "__firstRun__"
}

public enum Page: RawRepresentable, Equatable, Hashable, Codable, Identifiable {
    public typealias RawValue = String

    public var id: String {
        rawValue
    }

    case splash, unlockContent, premium, custom(URL)

    public init?(rawValue: String) {
        switch rawValue {
        case "splash":
            self = .splash
        case "unlockContent":
            self = .unlockContent
        case "premium":
            self = .premium
        default:
            return nil
        }
    }

    public var rawValue: String {
        String(describing: self)
    }
}

public class AppsFlyerSDKEventContainer: ObservableObject {
    @Published var event: AppsFlyerSDKEvent?
}

public struct AppsFlyerSDKEvent: Hashable {
    let id: String = UUID().uuidString
    let name: String
    let values: [String: AnyHashable]?

    init(name: String, values: [String: AnyHashable]? = nil) {
        self.name = name
        self.values = values
    }
}

public enum SDKEnv { case dev, production }

public struct LogOptions: OptionSet {
    public let rawValue: Int

    public static let native = LogOptions(rawValue: 1 << 0)
    public static let js = LogOptions(rawValue: 1 << 1)
    public static let all: LogOptions = [.native, .js]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
public enum APNSReciveActionDetails {
    case appOpened, duringSession
}

public enum APNSAction {
    case didRegisterForNotifications(token: String),
         didFailToRegisterForNotifications(error: Error),
         didReceive(notification: [AnyHashable: Any] /* UNNotification */, details: APNSReciveActionDetails)
}

public typealias JWTAuthHeader = (secret: [UInt8], key: UInt8, experation: Date)

public typealias SDKNotificationHandler = (APNSAction) -> Void

public struct SDKConfig {
    public typealias AppsFlyerConfigType = (appId: String, devKey: String)
    let domainURL: URL

    let appsFlyer: AppsFlyerConfigType?
    let env: SDKEnv
    let logOptions: LogOptions?
    let userId: String?
    let analyticvCallback: ((String, [String: Any]?) -> Void)?
    let apnsHandler: SDKNotificationHandler?
    public private(set) var jWTAuthHeader: JWTAuthHeader?

    public init(baseURL: URL,
                appsFlyer: AppsFlyerConfigType? = nil,
                env: SDKEnv = .production,
                logOptions: LogOptions? = LogOptions.all,
                forceUserId: String? = nil,
                forceSessionId: String? = nil,
                apnsHandler: SDKNotificationHandler? = nil,
                jWTAuthHeader: JWTAuthHeader? = nil,
                analyticvCallback: ((String, [String: Any]?) -> Void)? = nil)
    {
        domainURL = baseURL
        self.appsFlyer = appsFlyer
        self.env = env
        self.logOptions = logOptions
        userId = forceUserId
        self.apnsHandler = apnsHandler
        self.jWTAuthHeader = jWTAuthHeader
        self.analyticvCallback = analyticvCallback
    }
}

public extension ATTrackingManager.AuthorizationStatus {
    var toString: String {
        switch self {
        case .authorized:
            return "authorized"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        @unknown default:
            return "@unknown"
        }
    }
}

enum LifecycleEventName: String { case active, inactive, foreground, background, terminate }
