////
////  File.swift
////
////
////  Created by Dubon Ya'ar on 23/10/2024.
////
//
//import Combine
//import Foundation
//import StoreKit
//import SwiftUI
//import UIKit
//import WebKit
//
//public class TheSDKLegacy: ObservableObject, AnyInternalSDK {
//    var delegate: SDKViewModelDelegate?
//
//    var showSDK: Binding<Bool>?
//
//    @AppStorage("isSubscribed") var isSubscribedStore: Bool = false
//
//    @Published
//    public internal(set) var isSubscribed: Bool = false {
//        didSet {
//            isSubscribedStore = isSubscribed
//        }
//    }
//
//    @ObservationIgnored
//    @AppStorage("userId") private var userIdStored: String = UUID().uuidString
//
//    @Published
//    public private(set) var userId: String! {
//        didSet {
//            userIdStored = userId
//        }
//    }
//
//    private(set) var analyticsSubject: PassthroughSubject<(String, [AnyHashable: Any]?), Never> = .init()
//
//    var webView: WKWebView?
//
//    private(set) var imidiateInstallTime: String?
//
//    private(set) var isFirstRun: Bool = false
//
//    var appVersion: String {
//        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
//    }
//
//    public required init(config: SDKConfig) {
//        self.isSubscribed = isSubscribedStore
//        self.userId = userIdStored
//    }
//
//    private func sendLifecycle(event: LifecycleEventName) {
//        sendPixelEvent(name: "appLifecycle", payload: ["status": event.rawValue])
//    }
//}
//
//// MARK: external API
//
//public extension TheSDKLegacy {
//    @discardableResult
//    func action(event: JSEventWrapper) async throws -> [String: Any]? {
//        switch event.name {
//        case "purchase":
//            // Handle purchase action
//            isSubscribed = true
//            return ["success": true, "subscribed": true]
//        default:
//            return nil
//        }
//    }
//
//    var isPresented: Bool {
//        delegate != nil
//    }
//
//    func isSimulatorOrTestFlight() -> Bool {
//        guard let path = Bundle.main.appStoreReceiptURL?.path else {
//            return false
//        }
//
//        return path.contains("CoreSimulator") || path.contains("sandboxReceipt")
//    }
//
//    func updateIsSubscribed(thoroughly: Bool = false) async throws -> Bool { true }
//
//    func restorePurchases() {}
//
//    func restorePurchasesAsync() async throws -> Bool { true }
//
//    func sendPixelEvent(name: String, queryItems: [URLQueryItem]? = nil, payload: [String: Any]? = nil) {}
//
//    func sendAppsflyerEvent(name: String, payload: [AnyHashable: Any]? = nil) {}
//
//    @discardableResult
//    func resetUserId() -> String {
//        userId = UUID().uuidString
//        return userId
//    }
//}
//
//public extension TheSDKLegacy {
//    func presentSDKView(page: Page,
//                        show: Binding<Bool>? = nil,
//                        modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
//                        initialPayload: [String: Any]? = nil,
//                        opeque: Bool = true,
//                        backgroundColor: Color? = nil,
//                        ignoreSafeArea: Bool = false,
//                        _ callback: SDKViewDismissCallback? = nil)
//    {
//        guard let topController = UIApplication.topViewController else {
//            show?.wrappedValue = false
//            return
//        }
//
//        topController.modalPresentationStyle = .fullScreen
//
//        var vc: SDKViewController!
//        vc = SDKViewController(sdk: self,
//                               page: page,
//                               initialPayload: initialPayload,
//                               opaque: opeque,
//                               backgroundColor: backgroundColor,
//                               ignoreSafeArea: ignoreSafeArea)
//        {
//            vc.dismiss(animated: true)
//            show?.wrappedValue = false
//            callback?($0)
//        }
//
//        vc.modalPresentationStyle = modalPresentationStyle
//        topController.present(vc, animated: true)
//    }
//}
