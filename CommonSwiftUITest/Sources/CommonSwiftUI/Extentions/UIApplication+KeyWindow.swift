//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 10/12/2024.
//

import Foundation
import UIKit
public extension UIApplication {
    static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
    }
}
