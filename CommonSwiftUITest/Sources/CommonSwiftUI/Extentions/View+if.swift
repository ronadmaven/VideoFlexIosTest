//
//  SwiftUIView.swift
//
//
//  Created by Dubon Ya'ar on 09/10/2024.
//

import SwiftUI

public extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, _ transform: (Self) -> Content, elseDo: ((Self) -> Content)? = nil) -> some View {
        if condition {
            transform(self)
        } else {
            if let elseDo {
                elseDo(self)
            } else {
                self
            }
        }
    }
}

public extension View {
    @ViewBuilder func ifLet<T, Content: View>(_ value: T?, _ transform: (Self, T) -> Content, elseDo: ((Self) -> Content)? = nil) -> some View {
        if let value {
            transform(self, value)
        } else {
            if let elseDo {
                elseDo(self)
            } else {
                self
            }
        }
    }
}

public extension View {
    @ViewBuilder func condition<Content: View>(_ condition: Bool, _ transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
