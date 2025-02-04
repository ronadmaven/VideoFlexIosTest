//
//  BorderedRectangle.swift
//  VideoFlex
//
//  Created by Sazza on 8/11/23.
//

import SwiftUI

struct BorderedRectangle: View {
    var body: some View {
        RoundedCorner(radius: 20, corners: [.bottomLeft,.topRight])
            .foregroundColor(.backgroundColor)
            .overlay(
                RoundedCorner(radius: 20, corners: [.bottomLeft,.topRight])
                    .stroke(Color.lightBlueColor, lineWidth: 1)
            )
    }
}

#Preview {
    BorderedRectangle()
}
