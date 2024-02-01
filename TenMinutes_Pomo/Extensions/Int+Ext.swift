//
//  Int+Ext.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2/2/24.
//

import Foundation

extension Int {
    
    func formattedTime(format: String = "%02i:%02i") -> String {
        let minutes = self / 60 % 60
        let seconds = self % 60
        return String(format: format, minutes, seconds)
    }
    
}
