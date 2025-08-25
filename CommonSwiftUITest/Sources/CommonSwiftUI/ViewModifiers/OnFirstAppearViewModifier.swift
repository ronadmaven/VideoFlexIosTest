
import Foundation

import SwiftUI

public struct OnFirstAppearViewModifier: ViewModifier {
    let callback: () -> Void

    @State private var didAppear: Bool = false

    public init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if !didAppear {
                didAppear = true
                callback()
            }
        }
    }
}

public extension View {
    func onFirstAppear(_ callback: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearViewModifier(callback))
    }
}
