//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 27/11/2024.
//

import Foundation

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}
