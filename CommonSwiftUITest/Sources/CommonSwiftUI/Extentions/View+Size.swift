//
//  File.swift
//
//
//  Created by Dubon Ya'ar on 14/09/2024.
//

import SwiftUI
import UIKit

extension View {
    public func width(_ width: CGFloat? = nil) -> some View {
        return frame(width: width)
    }

    public func height(_ height: CGFloat? = nil) -> some View {
        return frame(height: height)
    }

    public func maxWidth(_ maxWidth: CGFloat?, alignment: Alignment = .center) -> some View {
        return frame(maxWidth: maxWidth, alignment: alignment)
    }

    public func maxHeight(_ maxHeight: CGFloat?, alignment: Alignment = .center) -> some View {
        return frame(maxHeight: maxHeight, alignment: alignment)
    }

    public func maxWidthInfinity(_ alignment: Alignment = .center) -> some View {
        return frame(maxWidth: .infinity, alignment: alignment)
    }

    public func maxHeightInfinity(_ alignment: Alignment = .center) -> some View {
        return frame(maxHeight: .infinity, alignment: alignment)
    }

    public func minWidth(_ maxWidth: CGFloat?, alignment: Alignment = .center) -> some View {
        return frame(minWidth: maxWidth, alignment: alignment)
    }

    public func minHeight(_ maxHeight: CGFloat?, alignment: Alignment = .center) -> some View {
        return frame(minHeight: maxHeight, alignment: alignment)
    }
}
