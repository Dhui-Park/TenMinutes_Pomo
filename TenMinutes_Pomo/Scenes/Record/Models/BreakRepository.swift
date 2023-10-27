//
//  BreakRepository.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/27.
//

import Foundation
import RealmSwift
import Realm
// 붕어빵틀
final class BreakRepository {
    
    static let shared = BreakRepository()
    
    let realm = try! Realm()
    
    private init() {
        // Private initialization to ensure just one instance is created.
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    // [-] crud
    // [-] create - add
    // [-] read - all, item
    // [-] update - item
    // [-] delete - all, item
    
    func addABreak(breakCreatedAt: Date = Date()){
        
        let entity = BreakEntity(breakCreatedAt: breakCreatedAt)
            
        try! realm.write {
            realm.add(entity)
        }
    }
    
    /// fetch records
    /// return RecordEntity[]
    func fetchBreaks() -> Results<BreakEntity> {
        // Get all todos in the realm
        let entities = realm.objects(BreakEntity.self)
        print(#fileID, #function, #line, "- entities.count: \(entities.count)")
        return entities
    }
    
    func fetchBreaksForToday() -> Results<BreakEntity>{
        let entities = realm.objects(BreakEntity.self).where {
            $0.breakCreatedAtDate == Date().makeDateString()
        }
        return entities
    }
    
    
    /// 단일 아이템 조회
    /// - Parameter id: ObjectId
    /// - Returns: BreakEntity?
    func fetchBreakItem(id: ObjectId) -> BreakEntity? {
        let specificBreakItem = realm.object(ofType: BreakEntity.self, forPrimaryKey: id)
        
        return specificBreakItem
    }
    
    
    #warning("TODO: - ")
    /// 아이템 수정
    /// - Parameters:
    ///   - id: ObjectId
    ///   - breakCount: Int
    func updateBreak(id: ObjectId, updatedTime: Date) {
        // All modifications to a realm must happen in a write block.
        // 1. id를 받는다.
        // 2. id에 해당하는 아이템을 찾는다.
        let breakToUpdate = realm.object(ofType: BreakEntity.self, forPrimaryKey: id)
        
        // 3. 수정할 데이터를 받는다.
        
        // 4. 데이터를 수정한다.
        try! realm.write {
            breakToUpdate?.breakCreatedAt = updatedTime
        }
    }
    
    
    /// 아이템 삭제
    /// - Parameter id: ObjectId
    func deleteBreak(id: ObjectId) {
        // All modifications to a realm must happen in a write block.
        guard let breakToDelete = realm.object(ofType: BreakEntity.self, forPrimaryKey: id) else { return }
        
        try! realm.write {
            // Delete the Todo.
            realm.delete(breakToDelete)
        }
        
    }
    
    
    /// 전체 삭제
    func deleteAllBreaks() {
        try! realm.write {
            // Delete all instances of Dog from the realm.
            let allEntities = realm.objects(BreakEntity.self)
            realm.delete(allEntities)
        }
    }
    
    
}
