//
//  SwiftUIView.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 26/11/2024.
//

import SwiftUI

public enum KeepAspectRationDriver { case width, height }
public struct KeepAspectRatioViewModifier: ViewModifier {
    public let ratio: Double
    public let driver: KeepAspectRationDriver

    @State private var size: CGSize = .zero

    public func body(content: Content) -> some View {
        content
            .frameReader { size = $0.size }
            .if(driver == .width) {
                $0.height(size.width * ratio)
            }
            .if(driver == .height) {
                $0.width(size.height * ratio)
            }
    }
}

public extension View {
    func keepAspect(ratio: Double, driver: KeepAspectRationDriver) -> some View {
        modifier(KeepAspectRatioViewModifier(ratio: ratio, driver: driver))
    }
}
