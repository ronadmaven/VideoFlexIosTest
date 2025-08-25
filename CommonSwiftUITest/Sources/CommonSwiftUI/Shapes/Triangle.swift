//
//  Triangle.swift
//  SwiftUIScoreBoard
//
//  Created by Dubon Ya'ar on 04/12/2023.
//

import SwiftUI

public struct Triangle: Shape {
    public enum Slant: Sendable { case left, right }
    private var slant: Slant?

    public init(slant: Slant? = nil) {
        self.slant = slant
    }

    public func path(in rect: CGRect) -> Path {
        var firstPoint: CGPoint! = .init(x: rect.midX, y: rect.minY)

        switch slant {
        case .left:
            firstPoint = .init(x: rect.minX, y: rect.minY)
        case .right:
            firstPoint = .init(x: rect.maxX, y: rect.minY)
        default:
            break
        }
        var p = Path()
        p.move(to: firstPoint)
        p.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        p.addLine(to: .init(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

#Preview {
    VStack {
        HStack {
            Spacer()
            Text("Left nSlant")
            Spacer()
            Text("Noramal")
            Spacer()
            Text("Right Slant")
            Spacer()
        }

        HStack {
            Triangle(slant: .left)
                .fill(.brown)
                .aspectRatio(1.0, contentMode: .fit)
            Triangle()
                .fill(.green)
                .aspectRatio(1.0, contentMode: .fit)
            //            .frame(width: 100, height: 100)

            Triangle(slant: .right)
                .fill(.blue)
                .aspectRatio(1.0, contentMode: .fit)
        }
        .frame(height: 100)
        .padding(40)
    }
}
