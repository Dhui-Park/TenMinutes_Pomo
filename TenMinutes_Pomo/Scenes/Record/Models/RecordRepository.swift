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
final class RecordRepository {
    
    static let shared = RecordRepository()
    
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
    
    func addRecord(){
        
        let entity = RecordEntity(gritCount: 0, gritDate: Date())
            
        try! realm.write {
            realm.add(entity)
        }
    }
    
    /// fetch records
    /// return RecordEntity[]
    func fetchRecords() -> Results<RecordEntity> {
        // Get all todos in the realm
        let entities = realm.objects(RecordEntity.self)
        
        return entities
    }
    
    
    /// 단일 아이템 조회
    /// - Parameter id: ObjectId
    /// - Returns: RecordEntity?
    func fetchRecordItem(id: ObjectId) -> RecordEntity? {
        let specificRecordItem = realm.object(ofType: RecordEntity.self, forPrimaryKey: id)
        
        return specificRecordItem
    }
    
    
    /// 아이템 수정
    /// - Parameters:
    ///   - id: ObjectId
    ///   - gritCount: Int
    func updateRecord(id: ObjectId, gritCount: Int) {
        // All modifications to a realm must happen in a write block.
        // 1. id를 받는다.
        // 2. id에 해당하는 아이템을 찾는다.
        let recordToUpdate = realm.object(ofType: RecordEntity.self, forPrimaryKey: id)
        
        // 3. 수정할 데이터를 받는다.
        
        // 4. 데이터를 수정한다.
        try! realm.write {
            recordToUpdate?.gritCount = gritCount
        }
    }
    
    
    /// 아이템 삭제
    /// - Parameter id: ObjectId
    func deleteRecord(id: ObjectId) {
        // All modifications to a realm must happen in a write block.
        guard let recordToDelete = realm.object(ofType: RecordEntity.self, forPrimaryKey: id) else { return }
        
        try! realm.write {
            // Delete the Todo.
            realm.delete(recordToDelete)
        }
        
    }
    
    
    /// 전체 삭제
    func deleteAllRecords() {
        try! realm.write {
            // Delete all instances of Dog from the realm.
            let allEntities = realm.objects(RecordEntity.self)
            realm.delete(allEntities)
        }
    }
    
    
}
