//
//  AppDelegate.swift
//  TenMinutes_Pomo
//
//  Created by dhui on 2023/10/01.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let shared01 : RecordRepository = RecordRepository.shared
//        let shared02 : RecordRepository = RecordRepository.shared
        
//        let test01 : RecordRepository = RecordRepository()
        
//        let test02 : RecordRepository = RecordRepository()
        
//        RecordRepository.shared.addRecord()
//        GritRepository.shared.deleteAllGrits()
        
//        let result = RecordRepository.shared.fetchRecords()

//        print(#fileID, #function, #line, "- result: \(result)")
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

