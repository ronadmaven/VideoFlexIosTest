//
//  AppDelegate.swift
//  VideoFlex
//
//  Created by Booysenberry on 10/7/22.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}

/// Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .OK, secondaryAction: UIAlertAction? = nil, tertiaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(primaryAction)
        if let secondary = secondaryAction { alert.addAction(secondary) }
        if let tertiary = tertiaryAction { alert.addAction(tertiary) }
        rootController?.present(alert, animated: true, completion: nil)
    }
}

extension UIAlertAction {
    static var OK: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }

    static var Cancel: UIAlertAction {
        UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
    while let presentedViewController = root?.presentedViewController {
        root = presentedViewController
    }
    return root
}
