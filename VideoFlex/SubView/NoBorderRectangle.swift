//
//  NoBorderRectangle.swift
//  VideoFlex
//
//  Created by Sazza on 8/11/23.
//

import SwiftUI

struct NoBorderRectangle: View {
    var body: some View {
        RoundedCorner(radius: 30, corners: [.bottomLeft,.topRight])
        .foregroundColor(.deepBlueColor)
    }
}

#Preview {
    NoBorderRectangle()
}
