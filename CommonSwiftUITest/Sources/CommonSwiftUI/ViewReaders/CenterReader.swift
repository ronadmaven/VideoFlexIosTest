//
//  CenterReader.swift
//  SpotiftMockup
//
//  Created by Dubon Ya'ar on 26/03/2024.
//

import SwiftUI

public struct CenterReader: View {
    public typealias OnChangeCallback = (_ frame: CGPoint) -> Void

    let space: CoordinateSpace
    let onChange: OnChangeCallback

    public init(space: CoordinateSpace, callback: @escaping OnChangeCallback) {
        self.space = space
        self.onChange = callback
    }

    public var body: some View {
        FrameReader(space: space) { frame in
            onChange(frame.mid)
        }
        .frame(width: 0, height: 0, alignment: .center)
    }
}

private extension CGRect {
    var mid: CGPoint { .init(x: midX, y: midY) }
}

public extension View {
    func centerReader(space: CoordinateSpace = .global, _ onChange: @escaping CenterReader.OnChangeCallback) -> some View {
        background(CenterReader(space: space, callback: onChange))
    }
}

struct CenterReaderPreview: View {
    var body: some View {
        ScrollView {
            Text("a")
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(.red)
                .centerReader(space: .named("scroll")) { frame in
                    print(frame)
                }
        }
        .coordinateSpace(name: "scroll")
    }
}

#Preview {
    CenterReaderPreview()
}
