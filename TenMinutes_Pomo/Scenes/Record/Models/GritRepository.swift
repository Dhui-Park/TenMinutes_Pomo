//
//  RecordRepository.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/10.
//

import Foundation
import RealmSwift
import Realm
// 붕어빵틀
final class GritRepository {
    
    static let shared = GritRepository()
    
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
    
    func addAGrit(gritCreatedAt: Date = Date()){
        
        let entity = GritEntity(gritCreatedAt: gritCreatedAt)
            
        try! realm.write {
            realm.add(entity)
        }
    }
    
    /// fetch records
    /// return RecordEntity[]
    func fetchGrits() -> Results<GritEntity> {
        // Get all todos in the realm
        let entities = realm.objects(GritEntity.self)
        print(#fileID, #function, #line, "- entities.count: \(entities.count)")
        return entities
    }
    
    func fetchGritsForToday() -> Results<GritEntity>{
        let entities = realm.objects(GritEntity.self).where {
            $0.gritCreatedAtDate == Date().makeDateString()
        }
        return entities
    }
    
    
    /// 단일 아이템 조회
    /// - Parameter id: ObjectId
    /// - Returns: GritEntity?
    func fetchGritItem(id: ObjectId) -> GritEntity? {
        let specificGritItem = realm.object(ofType: GritEntity.self, forPrimaryKey: id)
        
        return specificGritItem
    }
    
    
    #warning("TODO: - ")
    /// 아이템 수정
    /// - Parameters:
    ///   - id: ObjectId
    ///   - gritCount: Int
    func updateGrit(id: ObjectId, updatedTime: Date) {
        // All modifications to a realm must happen in a write block.
        // 1. id를 받는다.
        // 2. id에 해당하는 아이템을 찾는다.
        let recordToUpdate = realm.object(ofType: GritEntity.self, forPrimaryKey: id)
        
        // 3. 수정할 데이터를 받는다.
        
        // 4. 데이터를 수정한다.
        try! realm.write {
            recordToUpdate?.gritCreatedAt = updatedTime
        }
    }
    
    
    /// 아이템 삭제
    /// - Parameter id: ObjectId
    func deleteGrit(id: ObjectId) {
        // All modifications to a realm must happen in a write block.
        guard let gritToDelete = realm.object(ofType: GritEntity.self, forPrimaryKey: id) else { return }
        
        try! realm.write {
            // Delete the Todo.
            realm.delete(gritToDelete)
        }
        
    }
    
    
    /// 전체 삭제
    func deleteAllRecords() {
        try! realm.write {
            // Delete all instances of Dog from the realm.
            let allEntities = realm.objects(GritEntity.self)
            realm.delete(allEntities)
        }
    }
    
    
}
