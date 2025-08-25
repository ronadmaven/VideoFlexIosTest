//
//  FrameReader.swift
//  SpotiftMockup
//
//  Created by Dubon Ya'ar on 26/03/2024.
//

import SwiftUI

public struct FrameReader: View {
    // public typealias OnChangeCallback = (CGRect) -> Void

    public typealias OnChangeCallback = (_ frame: CGRect) -> Void

    let space: CoordinateSpace
    let onChange: OnChangeCallback

    init(space: CoordinateSpace, callback: @escaping OnChangeCallback) {
        self.space = space
        onChange = callback
    }

    public var body: some View {
        if #available(iOS 17, *) {
            GeometryReader { geom in
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear { onChange(geom.frame(in: space)) }
                    .onChange(of: geom.frame(in: space)) { _, newValue in onChange(newValue) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            GeometryReader { geom in
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear { onChange(geom.frame(in: space)) }
                    .onChange(of: geom.frame(in: space)) { newValue in onChange(newValue) }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

public extension View {
    func frameReader(space: CoordinateSpace = .global, _ onChange: @escaping FrameReader.OnChangeCallback) -> some View {
        background(FrameReader(space: space, callback: onChange))
    }
}

struct FrameReaderPreview: View {
    var body: some View {
        ScrollView {
            Text("a")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.red)
                .frameReader(space: .named("scroll")) { frame in
                    print(frame)
                }
        }
        .coordinateSpace(name: "scroll")
    }
}

#Preview {
    FrameReaderPreview()
}
