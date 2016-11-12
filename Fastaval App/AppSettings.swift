//
//  AppSettings.swift
//  Fastaval App
//
//  Created by Peter Lind on 14/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import RealmSwift

class AppSettings : Object, DirectoryItem {

    dynamic var language = "en"
    
    dynamic var refreshInterval = 15 * 60
    
    dynamic var allowNotifications = true
    
    dynamic var id = 1
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.appSettings
    }
    
    private func update() {
        Broadcaster.sharedInstance.publish(message: AppMessages.settings)
    }
    
    private func syncData() {
        let realm = try! Realm()
        
        let result = realm.objects(AppSettings.self)
        
        if result.count == 1 {
            try! realm.write {
                self.language = result[0].language
                self.refreshInterval = result[0].refreshInterval
                self.allowNotifications = result[0].allowNotifications
                
            }
        }
    }
    
    func setRefreshRate(_ rate : RefreshRate) -> AppSettings {
        let realm = try! Realm()
        
        try! realm.write {
            self.refreshInterval = rate.convertToSeconds()

            realm.add(self, update: true)
        }

        update()
        
        return self
    }
    
    func getRefreshRate() -> RefreshRate {
        syncData()
        
        return RefreshRate.secondsToCode(refreshInterval)
    }

    func setLanguage(_ language : AppLanguage) -> AppSettings {
        let realm = try! Realm()
        
        try! realm.write {
            self.language = language.toString()
            
            realm.add(self, update: true)
        }
        
        update()
        
        return self
    }
    
    func getLanguage() -> AppLanguage {
        syncData()
        
        return AppLanguage.parseString(language)
    }

    func setUseNotifications(_ allow : Bool) -> AppSettings {
        let realm = try! Realm()
        
        try! realm.write {
            self.allowNotifications = allow
            
            realm.add(self, update: true)
        }
        
        update()
        
        return self
    }
    
    func getUseNotifications() -> Bool {
        syncData()
        
        return allowNotifications
    }
}
