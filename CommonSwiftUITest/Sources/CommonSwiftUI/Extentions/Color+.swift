//
//  Color+.swift
//  WalkOnBy
//
//  Created by Dubon Ya'ar on 17/06/2024.
//

import SwiftUI

public extension Color {
    static var random: Color {
        Color(hue: Double.random(in: 0 ... 0.99), saturation: Double.random(in: 0.5 ... 1.0), brightness: Double.random(in: 0.5 ... 1.0))
    }
}

struct RandomColorPreview: PreviewProvider {
    struct ContainerView: View {
        @State var f: CGRect = .zero
        var body: some View {
            LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 3)) {
                ForEach(0 ..< 18) { _ in
                    Color.random
                        .aspectRatio(1.0, contentMode: .fill)
                        .frameReader({ f = $0 })
                        .cornerRadius(f.width)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(20)
        }
    }

    static var previews: some View {
        ContainerView()
    }
}
