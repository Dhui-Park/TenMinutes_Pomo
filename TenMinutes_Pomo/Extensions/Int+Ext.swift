//
//  Int+Ext.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 1/31/24.
//

import Foundation

/// extension
extension Int {
    /// @frozen?
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
