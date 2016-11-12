//
//  Barcode.swift
//  Fastaval App
//
//  Created by Peter Lind on 14/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit

class Barcode : Stateful, RemoteDependency, DirectoryItem, Subscriber {
    
    private let infosysApi : JsonApi
    
    private var state = BarcodeState.notReady
    
    private let settings : AppSettings
    
    private var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }
    
    init(infosysApi : JsonApi, settings: AppSettings) {
        self.infosysApi = infosysApi
        self.settings = settings
    }
    
    func getState() -> BarcodeState {
        return state
    }
    
    func initialize() {
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.RemoteSyncType)
    }

    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.barcode
    }
    
    
    func receive(_ message: Message) {
        
    }
}
