//
//  SceneDelegate.swift
//  ScanPDF
//
//  Created by Dubon Ya'ar on 29/01/2025.
//

import Foundation

import UIKit

var wasLaunchedFromNotification = false

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if connectionOptions.notificationResponse != nil {
            wasLaunchedFromNotification = true
        }
    }
}
