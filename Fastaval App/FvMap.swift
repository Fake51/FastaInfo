//
//  FvMap.swift
//  Fastaval App
//
//  Created by Peter Lind on 03/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import Just
import RealmSwift

class FvMap : Stateful, RemoteDependency, DirectoryItem, Subscriber {

    private var state = FvMapState.notReady
    
    private var highlightedRoom : String?

    private let infosysApi : JsonApi
    
    private let settings : AppSettings

    private var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }

    private let locationProvider: FileLocationProvider
    
    init(infosysApi: JsonApi, settings: AppSettings, locationProvider: FileLocationProvider) {
        self.infosysApi = infosysApi
        self.settings = settings
        self.locationProvider = locationProvider
        
    }
  
    func receive(_ message: Message) {
        infosysApi.isUpdatedMapAvailable(lastUpdate: Date()) {(_ updateAvailable: Bool) in
            if updateAvailable {
                self.getMap()
                
            }
            
        }
    
    }
    
    private func getMap() {
        infosysApi.retrieveMap(location: locationProvider.getMapLocation(), completedHandler:  {
            Broadcaster.sharedInstance.publish(message: AppMessages.map)
            self.state = FvMapState.ready
            
        })
        
    }
    
    func initialize() {
        let fileURL = locationProvider.getMapLocation()
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            getMap()
            
        } else {
            state = FvMapState.ready
            
        }
        
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.RemoteSyncType)
    }
    
    func getState() -> FvMapState {
        return state
    }

    func setHighlightedRoom(room: String?) {
        highlightedRoom = room
    }
    
    func getHighlightedRoom() -> String? {
        return highlightedRoom
    }

    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.map
    }
}
