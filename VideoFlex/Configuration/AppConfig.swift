//
//  AppConfig.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import SwiftUI
import Foundation
import AVFoundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-7548745678690435/9522335098"
    
    // MARK: - Settings flow items
    static let emailSupport = "hey@booysenberry.com"
    static let privacyURL: URL = URL(string: "https://www.booysenberry.com/videoflex-app")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!
    
    // MARK: - Generic Configurations
    static let appLaunchDelay: TimeInterval = 1.5
    static let videoGIFMaxDuration: Double = 5.0
    static let videoGIFMaxFramesPerSecond: Int = 15
    static let mergedVideoResolution: CGSize = CGSize(width: 1280, height: 720)
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "VideoFlex.Premium"
}

// MARK: - Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case premium, settings
    var id: Int { hashValue }
}

// MARK: - Selected Video tool type
enum VideoToolType {
    case regular, videoGIF, mergeVideos
    
    /// Max video duration only for Video to GIF
    var videoDuration: Double? {
        self == .videoGIF ? AppConfig.videoGIFMaxDuration : nil
    }
    
    /// Bottom sheet title
    var title: String {
        switch self {
        case .regular: return "Video to Audio"
        case .videoGIF: return "Video to GIF"
        case .mergeVideos: return "Merge Videos"
        }
    }
}

// MARK: - Color configurations
extension Color {
    static let darkGrayColor: Color = Color("DarkGrayColor")
    static let extraDarkGrayColor: Color = Color("ExtraDarkGrayColor")
    static let accentLightColor: Color = Color("AccentLightColor")
    static let backgroundColor: Color = Color("BackgroundColor")
    static let lightColor: Color = Color("LightColor")
    static let deepBlueColor: Color = Color("DeepBlueColor")
    static let lightBlueColor: Color = Color("LightBlueColor")
    static let lightGrayColor: Color = Color("LightGrayColor")
    static let bgCircleColor: Color = Color("BgCircleColor")
}

