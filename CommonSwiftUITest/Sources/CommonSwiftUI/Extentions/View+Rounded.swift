//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 07/08/2024.
//

import SwiftUI

public struct RoundedViewModifier: ViewModifier {
    @State private var size: CGSize = .zero

    public func body(content: Content) -> some View {
        content
            .cornerRadius(min(size.width, size.width) / 2)
            .frameReader { size = $0.size }
    }
}

public extension View {
    var rounded: some View {
        modifier(RoundedViewModifier())
    }
}

#Preview {
    VStack {
        Text("Horizontal")

        Color.blue
            .frame(width: 200, height: 60)
            .rounded
            .padding(.bottom, 40)

        Text("Vertical")

        Color.blue
            .frame(width: 60, height: 100)
            .rounded
    }
}
