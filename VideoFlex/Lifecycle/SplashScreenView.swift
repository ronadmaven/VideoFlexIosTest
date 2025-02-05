//
//  SplashView.swift
//  ScanPDF
//
//  Created by Dubon Ya'ar on 29/09/2024.
//

import SDK
import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var sdk: TheSDK

    @Binding var show: Bool
    @State private var showSDK: Bool = true

    var body: some View {
        ZStack {
            if showSDK {
                SDKView(model: sdk, page: .splash, show: $show)
                    .ignoresSafeArea()
            }
        }
        .onDisappear {
            showSDK = false
        }
    }
}
