//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 26/11/2024.
//

import Foundation

import SwiftUI

public struct OnFirstDisappearViewModifier: ViewModifier {
    let callback: () -> Void

    @State private var didAppear: Bool = false

    public init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }

    public func body(content: Content) -> some View {
        content.onDisappear {
            if !didAppear {
                didAppear = true
                callback()
            }
        }
    }
}

public extension View {
    func onFirstDisappear(_ callback: @escaping () -> Void) -> some View {
        modifier(OnFirstDisappearViewModifier(callback))
    }
}
