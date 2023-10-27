//
//  Date+Ext.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/25.
//

import Foundation

extension Date {
    static func removeTime(date: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let dateRemoveTime = Calendar.current.date(from: components)
        return dateRemoveTime!
    }
    
    public var removeTimeStamp : Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
    
    func makeDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: self)
    }
}
