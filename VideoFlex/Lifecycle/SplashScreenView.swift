//
//  SplashView.swift
//  ScanPDF
//
//  Created by Dubon Ya'ar on 29/09/2024.
//

import CommonSwiftUI
import SDK
import SwiftUI
struct SplashScreen: View {
    @EnvironmentObject var sdk: TheSDK
    @State var show: Bool = true
    @State var showDashboard: Bool = false

    var body: some View {
        ZStack {
            if show {
                SDKView(model: sdk, page: .splash, show: $show)
                    .ignoresSafeArea()
            }

            NavigationLink(
                destination: DashboardContentView(),
                isActive: $showDashboard
            ) {
                EmptyView()
            }
        }
        .onChange(of: show) { newValue in
            if !newValue {
                showDashboard = true
            }
        }
    }
}
