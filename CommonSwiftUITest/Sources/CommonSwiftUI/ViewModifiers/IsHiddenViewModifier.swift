//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 19/11/2024.
//

import Foundation

import SwiftUI

struct IsHiddenViewModifier: ViewModifier {
    let isHidden: Bool
    func body(content: Content) -> some View {
        if !isHidden {
            content
        }
    }
}

public extension View {
    func isHidden(_ isHidden: Bool = true) -> some View {
        modifier(IsHiddenViewModifier(isHidden: isHidden))
    }
}
