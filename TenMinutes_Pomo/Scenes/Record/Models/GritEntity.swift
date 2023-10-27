//
//  RecordEntity.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/10.
//

import Foundation
import RealmSwift
// data structure
// daily filter feature 기능
//- [ ] 공부 기록
//    - [ ] 고유 id 필요 - PK
//    - [ ] ***집중  횟수: Int -> 중요하다고 생각한것 잘 보이게 디자인
//    - [ ] 공부 시각: DateTime

// _id

class GritEntity: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gritCreatedAt: Date
    @Persisted var gritCreatedAtDate: String
    
    convenience init(gritCreatedAt: Date) {
        self.init()
        self.gritCreatedAt = gritCreatedAt
        self.gritCreatedAtDate = gritCreatedAt.makeDateString()
    }
}

//let date = Date() // save date, so all components use the same date
//let calendar = Calendar.current // or e.g. Calendar(identifier: .persian)
//
//let hour = calendar.component(.hour, from: date)
