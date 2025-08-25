//
//  JSView.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 02/07/2024.
//

import Combine
import Foundation
import SwiftUI
import WebKit

public typealias SDKViewDismissCallback = ([String: Any]) -> Void?

// public struct SDKView: UIViewRepresentable {
//    public init(model: TheSDK,
//                page: Page,
//                show: Binding<Bool>,
//                initialPayload: [String: Any]? = nil,
//                opeque: Bool = true,
//                backgroundColor: Color? = nil,
//                ignoreSafeArea: Bool = false,
//                _ callback: SDKViewDismissCallback? = nil)
//    {}
//
//    public func makeUIView(context: Context) -> UIView {
//        let container: UIView = .init()
//        container.backgroundColor = .red
//        return container
//    }
//
//    public func updateUIView(_ uiView: UIView, context: Context) {}
// }

public struct SDKView: View {
    let callback: SDKViewDismissCallback?
    let sdk: TheSDK
    @Binding var show: Bool
    public init(model: TheSDK,
                page: Page,
                show: Binding<Bool>,
                initialPayload: [String: Any]? = nil,
                opeque: Bool = true,
                backgroundColor: Color? = nil,
                ignoreSafeArea: Bool = false,
                _ callback: SDKViewDismissCallback? = nil)
    {
        sdk = model
        self.callback = callback
        _show = show
    }

    public var body: some View {
        VStack {
            HStack {
                Spacer()

                Button("close") {
                    show = false
                    callback?([:])
                }
                .padding(.top, 30)
                .frame(height: 40)
            }
            Spacer()

            Text("Paywall Mockup")
                .font(.largeTitle)

            Spacer()

            Button("Subscribe") {
                sdk.isSubscribed = true
                show = false
                callback?([:])
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .cornerRadius(10)
            .foregroundColor(.white)
            .padding(.bottom, 1)
        }
        .padding(30)
        .onAppear {
            if sdk.isSubscribed {
                show = false
                callback?([:])
            }
        }
    }
}
//
//#Preview {
//    SDKView(model: TheSDK(config: .init(baseURL: URL(string: "")!)), page: .splash, show: .constant(true)) { _ in }
//        .ignoresSafeArea()
//}
