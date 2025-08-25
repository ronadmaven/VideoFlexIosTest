//
//  File 2.swift
//
//
//  Created by Dubon Ya'ar on 25/09/2024.
//

import SwiftUI
import UIKit

public extension View {
    // This function captures a snapshot of the current SwiftUI view as a UIImage
    func snapshot() -> UIImage {
        // Create a UIHostingController with the SwiftUI view
        let controller = UIHostingController(rootView: self)

        // Find the size of the SwiftUI view
        let size = controller.view.intrinsicContentSize

        // Set the controller's view size
        controller.view.frame = CGRect(origin: .zero, size: size)

        // Add the view to the current context for rendering
        let window = UIWindow()
        window.rootViewController = controller
        window.makeKeyAndVisible()

        // Render the view as an image
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

public struct SnapshotViewModifier: ViewModifier {
    @Binding public var snapshotImage: UIImage?
    public var trigger: Bool

    public func body(content: Content) -> some View {
        if #available(iOS 17, *) {
            content
                .onChange(of: trigger) { _, newValue in
                    if newValue {
                        print(content)
                        snapshotImage = content.snapshot()
                    }
                }
        } else {
            content
                .onChange(of: trigger) { newValue in
                    if newValue {
                        print(content)
                        snapshotImage = content.snapshot()
                    }
                }
        }
    }
}

public extension View {
    func snapshot(snapshotImage: Binding<UIImage?>, trigger: Bool) -> some View {
        return modifier(SnapshotViewModifier(snapshotImage: snapshotImage, trigger: trigger))
    }
}
