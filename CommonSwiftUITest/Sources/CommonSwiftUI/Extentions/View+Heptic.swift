//
//  UIView+Heptic.swift
//  QRFun
//
//  Created by Dubon Ya'ar on 20/07/2024.
//

import SwiftUI
import UIKit

extension View {
    func simpleHeptic(trigger: Bool, type: UINotificationFeedbackGenerator.FeedbackType = .success) -> some View {
        if trigger {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
        return self
    }
}
