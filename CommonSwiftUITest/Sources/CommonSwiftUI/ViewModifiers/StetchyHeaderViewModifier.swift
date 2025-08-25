//
//  StetchyHeaderViewModifier.swift
//  SpotiftMockup
//
//  Created by Dubon Ya'ar on 26/03/2024.
//

import SwiftUI

struct StetchyHeaderViewModifier: ViewModifier {
    let initialHeight: CGFloat
    let coordinateSpace: CoordinateSpace = .global
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .frame(height: stretchedHeight(geometry))
                .aspectRatio(contentMode: .fill)
                .clipped()
                .offset(y: -yOffset(geometry))
                .brightness(brigtness(geometry))
        }
        .frame(height: initialHeight)
    }

    private func brigtness(_ geo: GeometryProxy) -> Double {
        let offset = yOffset(geo)
        return -max(0, -offset + 59) / 100
        // geo.frame(in: coordinateSpace).minY
    }

    private func yOffset(_ geo: GeometryProxy) -> CGFloat {
        geo.frame(in: coordinateSpace).minY
    }

    private func stretchedHeight(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        // return offset > 0 ? (initialHeight + offset) : initialHeight
        return initialHeight + offset
    }
}

public extension View {
    func asStretchyHeader(initialHeight: CGFloat) -> some View {
        modifier(StetchyHeaderViewModifier(initialHeight: initialHeight))
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)

        ScrollView {
            VStack(spacing: 50) {
                Rectangle()
                    .fill(Color.green)
                    .overlay(
                        ZStack {
                            AsyncImage(url: URL(string: "https://picsum.photos/800/800"))

                            Text("TITLE")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .shadow(radius: 20)
                        }
                    )
                    .asStretchyHeader(initialHeight: 300)
                Rectangle().fill(.red)
                    .frame(width: 100, height: 100)
                Rectangle().fill(.red)
                    .frame(width: 100, height: 100)
                Rectangle().fill(.red)
                    .frame(width: 100, height: 100)
                Rectangle().fill(.red)
                    .frame(width: 100, height: 100)
            }
        }
    }
}
