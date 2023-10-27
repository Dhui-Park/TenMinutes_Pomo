//
//  BreakEntity.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/27.
//

import Foundation
import RealmSwift

class BreakEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var breakCreatedAt: Date
    @Persisted var breakCreatedAtDate: String
    
    convenience init(breakCreatedAt: Date) {
        self.init()
        self.breakCreatedAt = breakCreatedAt
        self.breakCreatedAtDate = breakCreatedAt.makeDateString()
    }
}
