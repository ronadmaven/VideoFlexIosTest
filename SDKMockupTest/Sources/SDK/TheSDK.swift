//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 23/10/2024.
//

import Combine
import Foundation
import StoreKit
import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
import WebKit

#if canImport(Observation)
import Observation
#endif

#if swift(>=5.9) && canImport(Observation) && (os(iOS) || os(tvOS) || os(watchOS) || os(visionOS))
@available(iOS 17.0, tvOS 17.0, watchOS 10.0, *)
@Observable
public class TheSDK {
    @ObservationIgnored
    var delegate: SDKViewModelDelegate?
    
    @ObservationIgnored
    var showSDK: Binding<Bool>?
    
    @ObservationIgnored
    @AppStorage("isSubscribed") var isSubscribedStore: Bool = false
    
    public internal(set) var isSubscribed: Bool = false {
        didSet {
            isSubscribedStore = isSubscribed
        }
    }
    
    @ObservationIgnored
    @AppStorage("userId") private var userIdStored: String = UUID().uuidString
    
    public private(set) var userId: String! {
        didSet {
            userIdStored = userId
        }
    }
    
    @ObservationIgnored
    private(set) var analyticsSubject: PassthroughSubject<(String, [AnyHashable: Any]?), Never> = .init()
    
    @ObservationIgnored
    var webView: WKWebView?
    
    @ObservationIgnored
    private(set) var imidiateInstallTime: String?
    
    @ObservationIgnored
    private(set) var isFirstRun: Bool = false
    
    @ObservationIgnored
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public required init(config: SDKConfig) {
        self.userId = userIdStored
        self.isSubscribed = isSubscribedStore
    }

    private func sendLifecycle(event: LifecycleEventName) {
        sendPixelEvent(name: "appLifecycle", payload: ["status": event.rawValue])
    }
}
#else
public class TheSDK: ObservableObject {
    var delegate: SDKViewModelDelegate?
    
    var showSDK: Binding<Bool>?
    
    @AppStorage("isSubscribed") var isSubscribedStore: Bool = false
    
    @Published
    public internal(set) var isSubscribed: Bool = false {
        didSet {
            isSubscribedStore = isSubscribed
        }
    }
    
    @AppStorage("userId") private var userIdStored: String = UUID().uuidString
    
    @Published
    public private(set) var userId: String! {
        didSet {
            userIdStored = userId
        }
    }
    
    private(set) var analyticsSubject: PassthroughSubject<(String, [AnyHashable: Any]?), Never> = .init()
    
    var webView: WKWebView?
    
    private(set) var imidiateInstallTime: String?
    
    private(set) var isFirstRun: Bool = false
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public required init(config: SDKConfig) {
        self.userId = userIdStored
        self.isSubscribed = isSubscribedStore
    }

    private func sendLifecycle(event: LifecycleEventName) {
        sendPixelEvent(name: "appLifecycle", payload: ["status": event.rawValue])
    }
}
#endif

// MARK: - Public API

public extension TheSDK {
    @discardableResult
    func action(event: JSEventWrapper) async throws -> [String: Any]? {
        switch event.name {
        case "purchase":
            // Handle purchase action
            isSubscribed = true
            return ["success": true, "subscribed": true]
        default:
            return nil
        }
    }

    var isPresented: Bool {
        delegate != nil
    }

    func isSimulatorOrTestFlight() -> Bool {
        guard let path = Bundle.main.appStoreReceiptURL?.path else {
            return false
        }

        return path.contains("CoreSimulator") || path.contains("sandboxReceipt")
    }

    func updateIsSubscribed(thoroughly: Bool = false) async throws -> Bool { true }

    func restorePurchases() {}

    func restorePurchasesAsync() async throws -> Bool { true }

    func sendPixelEvent(name: String, queryItems: [URLQueryItem]? = nil, payload: [String: Any]? = nil) {}

    func sendAppsflyerEvent(name: String, payload: [AnyHashable: Any]? = nil) {}

    @discardableResult
    func resetUserId() -> String {
        userId = UUID().uuidString
        return userId
    }
    
    var implementationType: String {
        #if swift(>=5.9) && canImport(Observation) && (os(iOS) || os(tvOS) || os(watchOS) || os(visionOS))
        return "Observable (iOS 17+)"
        #else
        return "ObservableObject (iOS 15-16)"
        #endif
    }
}

#if canImport(UIKit)
public extension TheSDK {
    func presentSDKView(page: Page,
                        show: Binding<Bool>? = nil,
                        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                        initialPayload: [String: Any]? = nil,
                        opeque: Bool = true,
                        backgroundColor: Color? = nil,
                        ignoreSafeArea: Bool = false,
                        _ callback: SDKViewDismissCallback? = nil)
    {
        guard let topController = UIApplication.topViewController else {
            show?.wrappedValue = false
            return
        }

        topController.modalPresentationStyle = .fullScreen

        var vc: SDKViewController!
        vc = SDKViewController(sdk: self,
                               page: page,
                               initialPayload: initialPayload,
                               opaque: opeque,
                               backgroundColor: backgroundColor,
                               ignoreSafeArea: ignoreSafeArea)
        {
            vc.dismiss(animated: true)
            show?.wrappedValue = false
            callback?($0)
        }

        vc.modalPresentationStyle = modalPresentationStyle
        topController.present(vc, animated: true)
    }
}

public extension UIApplication {
    static var topViewController: UIViewController? {
        guard let keyWindow = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return nil }

        var topController = keyWindow.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }

        return topController
    }
}
#endif
