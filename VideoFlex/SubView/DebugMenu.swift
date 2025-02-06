//
//  DebugMenu.swift
//  Unlock-r
//
//  Created by Dubon Ya'ar on 02/11/2024.
//

import AdSupport
import CommonSwiftUI
import SDK
import SwiftUI
struct DebugMenu: View {
    @EnvironmentObject private var sdk: TheSDK
    @State private var showRestartApp: Bool = false
    @State private var heptic: Bool = false
    var body: some View {
        Menu("🥳") {
            Button("Copy User Id", action: {
                if let userId = sdk.userId {
                    UIPasteboard.general.string = userId
                }
            })

            Button("Reset User Id", action: {
                sdk.resetUserId()
                showRestartApp = true
            })

            Button("Copy Advertising Id", action: {
                UIPasteboard.general.string = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            })

            if let apnToken = APNSManager.shared.token {
                Button("Copy APN Token", action: {
                    UIPasteboard.general.string = apnToken
                })
            }
        }
        .font(.title)
        .foregroundStyle(.black)
        .onFirstAppear {
            heptic.toggle()
        }
        .onChange(of: showRestartApp) { newValue in
            print(newValue)
            if newValue {
                guard let keyWindow = UIApplication.shared.connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow }) else { return }

                var topController = keyWindow.rootViewController
                while let presentedController = topController?.presentedViewController {
                    topController = presentedController
                }

                if let topController {
                    let label = UILabel()
                    label.text = "restart app".capitalized
                    label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                    label.textColor = .white
                    label.font = .systemFont(ofSize: 20, weight: .bold)
                    label.isUserInteractionEnabled = true // Enable interaction
                    label.textAlignment = .center
                    label.addGestureRecognizer(UITapGestureRecognizer())
                    topController.view.addSubview(label)

                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.leadingAnchor.constraint(equalTo: topController.view.leadingAnchor).isActive = true
                    label.trailingAnchor.constraint(equalTo: topController.view.trailingAnchor).isActive = true
                    label.topAnchor.constraint(equalTo: topController.view.topAnchor).isActive = true
                    label.bottomAnchor.constraint(equalTo: topController.view.bottomAnchor).isActive = true
                }
            }
        }
    }
}
