//
//  SwiftUIView.swift
//
//
//  Created by Dubon Ya'ar on 02/10/2024.
//

import SwiftUI

public struct CustomSwitch: View {
    @Binding var isOn: Bool
    @State var buttonColor: Color
    @State var backgroundColor: Color
    @State var onColor: Color

    @State private var animatedIsOn: Bool = false
    @State private var animatedIsTapped: Bool = false
    @State private var buttonHeight: CGFloat = 0

    public init(isOn: Binding<Bool>,
                buttonColor: Color = .white,
                backgroundColor: Color = .yellow,
                onColor: Color = .green) {
        _isOn = isOn
        self.buttonColor = buttonColor
        self.backgroundColor = backgroundColor
        self.onColor = onColor
    }

    public var body: some View {
        if #available(iOS 17, *) {
            ZStack(alignment: animatedIsOn ? .trailing : .leading) {
                Rectangle()
                    .fill(animatedIsOn ? onColor : backgroundColor)
                    .rounded

                RoundedRectangle(cornerRadius: buttonHeight / 2)
                    .fill(buttonColor)
                    .padding(5)
                    .width(animatedIsTapped ? buttonHeight * 1.4 : buttonHeight)
                    .frameReader {
                        buttonHeight = $0.size.height
                    }
            }
            .onChange(of: isOn) { _, newValue in
                withAnimation {
                    animatedIsOn = newValue
                }
            }
            .onAppear {
                animatedIsOn = isOn
            }
            ._onButtonGesture { value in
                withAnimation {
                    animatedIsTapped = value
                }

                if !value {
                    isOn.toggle()
                }

            } perform: {
            }
        }
    }
}

struct CustomSwitchPreview: View {
    @State var isOn: Bool = false
    var body: some View {
        CustomSwitch(isOn: $isOn, backgroundColor: .pink, onColor: .purple)
            .frame(width: 100, height: 50)
    }
}

#Preview {
    CustomSwitchPreview()
}
