//
//  BgCircleView.swift
//  VideoFlex
//
//  Created by Sazza on 8/11/23.
//

import SwiftUI

struct BgCircleView: View {
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.bgCircleColor, lineWidth: UIScreen.screenWidth / 6.55)
                .rotationEffect(.degrees(-90))
                .offset(x: -UIScreen.screenWidth / 13.1, y: -UIScreen.screenWidth / 6.55)
                .frame(width: UIScreen.screenWidth + UIScreen.screenWidth / 13.1)
                .clipped()
            Spacer()
        }
        .frame(width: UIScreen.screenWidth)
        .ignoresSafeArea()
    }
}

#Preview {
    BgCircleView()
}
