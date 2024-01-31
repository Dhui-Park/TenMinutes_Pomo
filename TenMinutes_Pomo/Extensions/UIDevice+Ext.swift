//
//  UIDevice+Ext.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 1/31/24.
//

import Foundation
import UIKit
// AV: AudioVisual
import AVFoundation

extension UIDevice {
    /// static func에 대해서
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Brrrrrr")
    }
}
