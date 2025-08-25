//
//  Untitled.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 06/02/2025.
//

import SwiftUI
public struct ButtonWithLongPress<Content: View>: View {
    let callback: () -> Void
    let label: () -> Content
    let longPressSecodns: TimeInterval
    let longPressCallback: () -> Void

    @State private var didLongPress = false
    @State private var didTapDown = false

    public init(callback: @escaping () -> Void,
                label: @escaping () -> Content,
                longPressSecodns: TimeInterval,
                longPressCallback: @escaping () -> Void) {
        self.callback = callback
        self.label = label
        self.longPressSecodns = longPressSecodns
        self.longPressCallback = longPressCallback
    }

    public var body: some View {
        Button {
            if !didLongPress {
                callback()
            }

            didLongPress = false

        } label: {
            label()
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 5, maximumDistance: 200).onEnded { _ in
                longPressCallback()
                didLongPress = true
            }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 0).onChanged { _ in
                if !didTapDown {
                    didTapDown = true
                    didLongPress = false
                }
            }
        )
    }
}
