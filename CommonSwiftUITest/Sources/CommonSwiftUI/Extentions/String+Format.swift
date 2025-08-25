//
//  File.swift
//  CommonSwiftUI
//
//  Created by Dubon Ya'ar on 04/12/2024.
//

import Foundation

public extension String {
    var capitalizedFirstLetter: String {
        prefix(1).uppercased() + dropFirst()
    }
}
