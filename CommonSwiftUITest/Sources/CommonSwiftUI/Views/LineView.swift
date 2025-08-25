//
//  SwiftUIView.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 04/12/2024.
//

import SwiftUI

public struct LineView: View {
    public init() {}
    public var body: some View {
        Rectangle()
            .height(1)
            .maxWidthInfinity()
    }
}

#Preview {
    LineView()
        .foregroundStyle(.green)
}
