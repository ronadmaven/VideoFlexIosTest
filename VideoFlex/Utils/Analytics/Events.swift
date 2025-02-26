//
//  AnalyticsEvents.swift
//  ScanPDF
//
//  Created by Dubon Ya'ar on 12/02/2025.
//

import Foundation

enum AnalyticsScreen: String { case dashboard,
                                    settings,
                                    mail,
                                    web,
                                    gallery
}

enum Events {
    // General
    struct AppPresentedScreen: AnalyticEventProtocol {
        let screen: AnalyticsScreen
        var parameters: [String: Any]? {
            ["screen": screen.rawValue]
        }
    }

    struct UserSavedImage: AnalyticEventProtocol {}
    struct UserStartedMeasurement: AnalyticEventProtocol {}
    struct UserResetMeasurement: AnalyticEventProtocol {}

    struct AppInitiatedRateApp: AnalyticEventProtocol {}
    struct UserInitiatedRateApp: AnalyticEventProtocol {}
    struct UserDidRateApp: AnalyticEventProtocol { let rate: Int }
    struct UserDismissedRateAppDialog: AnalyticEventProtocol { }
    struct UserTappedFunFactButton: AnalyticEventProtocol { }

    struct UserStartedMeasuring: AnalyticEventProtocol { }
    struct UserEndedMeasuring: AnalyticEventProtocol { }
    struct UserChangedMeasurementUnit: AnalyticEventProtocol { let unit: String }
    struct UserCopiedMeasurement: AnalyticEventProtocol { }
    struct UserTappedInfoButton: AnalyticEventProtocol { }

    struct UserTappedVideoToGif: AnalyticEventProtocol { }
    struct UserTappedMergeVideo: AnalyticEventProtocol { }
    struct UserTappedImportFromFileButton: AnalyticEventProtocol { }
    struct UserTappedImportPhotoFileButton: AnalyticEventProtocol { }

    struct UserImportVideoFromPhotoGalery: AnalyticEventProtocol { }
    struct UserImportVideoFromFile: AnalyticEventProtocol { }
    struct UserTappedPremiumButton: AnalyticEventProtocol { }
}
