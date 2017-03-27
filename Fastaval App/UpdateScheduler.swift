//
//  UpdateScheduler.swift
//  Fastaval App
//
//  Created by Peter Lind on 16/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class UpdateScheduler : Subscriber {
    private let settings : AppSettings

    private var uuid = UUID().uuidString
    
    private var syncTimer : Timer?
    
    private var lastUpdate = 0
    
    func getSubscriberId() -> String {
        return uuid
    }

    init(appSettings : AppSettings) {
        self.settings = appSettings
        
        self.setupSchedule()
    }
    
    func receive(_ message: Message) {
        setupSchedule()
    }

    func getLastUpdateTimestamp() -> Int {
        let realm = try! Realm()
        let cacheData = realm.objects(RemoteSyncTimestamp.self).filter("timestamp > 0")
        
        if cacheData.count > 0 {
            let temp = cacheData.first!
            
            if temp.timestamp >= lastUpdate {
                lastUpdate = temp.timestamp
            }
        }
        
        return lastUpdate
    }
    
    private func setupSchedule() {
        if let timer = syncTimer {
            if timer.isValid {
                timer.invalidate()
            }
        }

        if settings.getRefreshRate() == RefreshRate.manual {
            syncTimer = nil
            return
        }

        let lastTimeStamp = getLastUpdateTimestamp()

        var seconds = TimeInterval(1)

        if lastTimeStamp > 0 {
            let next = Date(timeIntervalSince1970: TimeInterval(lastTimeStamp + settings.getRefreshRate().convertToSeconds()))
            
            if next.compare(Date()) != ComparisonResult.orderedAscending {
                seconds = next.timeIntervalSince(Date())
            }
            
        } else {
            seconds = 1
        }

        syncTimer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(self.timerDidFire), userInfo: nil, repeats: false)
    }
    
    func updateSyncTimestamp() {
        let now = Int(Date().timeIntervalSince1970)

        self.lastUpdate = now

        DispatchQueue(label: "background").async {
            let realm = try! Realm()
            
            let cacheData = realm.objects(RemoteSyncTimestamp.self).first
            
            try! realm.write {
                if cacheData != nil {
                    cacheData!.timestamp = now
                } else {
                    realm.add(RemoteSyncTimestamp(value: ["timestamp" : now]))
                }
            }
            
        }
    }
    
    dynamic func timerDidFire(timer: Timer!) {
        Broadcaster.sharedInstance.publish(message: AppMessages.remoteSync)
        
        self.updateSyncTimestamp()
        self.setupSchedule()
    }
}
