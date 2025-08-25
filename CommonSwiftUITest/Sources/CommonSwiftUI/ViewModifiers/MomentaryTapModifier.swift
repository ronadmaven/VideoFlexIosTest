//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 23/04/2025.
//

import SwiftUI

extension View {
    public func momentaryTapModifier(_ isOn: Binding<Bool>, tolerance: TimeInterval = 0.3) -> some View {
        modifier(MomentaryTapModifier(isOn: isOn, tolerance: tolerance))
    }
}

struct MomentaryTapModifier: ViewModifier {
    @Binding var isOn: Bool
    let tolerance: TimeInterval

    @State private var tapTime: Date?

    init(isOn: Binding<Bool>, tolerance: TimeInterval = 0.3) {
        _isOn = isOn
        self.tolerance = tolerance
    }

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if tapTime == nil {
                            tapTime = .now
                            DispatchQueue.main.asyncAfter(deadline: .now() + tolerance) {
                                if let tapTime, Date.now.timeIntervalSince(tapTime) >= tolerance {
                                    isOn.toggle()
                                }
                            }
                        }
                    }
                    .onEnded { _ in
                        guard let tapTime else { return }
                        let duration = Date.now.timeIntervalSince(tapTime)
                        if duration < tolerance {
                            isOn.toggle()
                        } else {
                            isOn = false
                        }
                        self.tapTime = nil
                    }
            )
    }
}
