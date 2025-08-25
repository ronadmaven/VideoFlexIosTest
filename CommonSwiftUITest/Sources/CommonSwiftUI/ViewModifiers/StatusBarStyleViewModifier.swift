//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 13/01/2025.
//

import SwiftUI

public struct StatusBarStyleModifier: UIViewControllerRepresentable {
    var style: UIStatusBarStyle

    public func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        uiViewController.overrideUserInterfaceStyle = (style == .lightContent) ? .dark : .light
        uiViewController.setNeedsStatusBarAppearanceUpdate()
    }
}

public extension View {
    func statusBarStyle(_ style: UIStatusBarStyle) -> some View {
        background(StatusBarStyleModifier(style: style))
    }
}
