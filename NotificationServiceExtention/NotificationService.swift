//
//  NotificationService.swift
//  APNSContentExtention
//
//  Created by Dubon Ya'ar on 12/02/2025.
//

import CommonSwiftUI
import SDK
import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    let sdk: TheSDK = .init(config: .init(baseURL:
        .init(string: "https://app.flex-vid.com")!,
        forceUserId: KeyChainUtil.retrieveStringFromKeychain(forKey: "userId")
    ))

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler

        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        if let pushId = bestAttemptContent?.userInfo["push_id"] {
            sdk.sendPixelEvent(name: "pushNotificationDidReceive", payload: ["push_id": pushId])
        }

        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"

            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)

            if let pushId = bestAttemptContent.userInfo["push_id"] {
                sdk.sendPixelEvent(name: "pushNotificationServiceExtensionTimeWillExpire", payload: ["push_id": pushId])
            }
        }
    }
}

// Graveyard
//
//            let url: URL = URL(string: "https://app.pdfviewz.com/collect")!
//                .appending(queryItems: [
//                    .init(name: "source", value: "event"),
//                    .init(name: "event", value: "pushNotificationDidReceive"),
//                    .init(name: "senderVersion", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""),
//
//                ])
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.httpBody = try? JSONSerialization.data(withJSONObject: ["push_id": pushId])
//            request.addValue("accept", forHTTPHeaderField: "application/json")
//
//            Task {
//                try await URLSession.shared.data(for: request)
//            }
