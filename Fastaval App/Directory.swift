//
//  Directory.swift
//  Fastaval App
//
//  Created by Peter Lind on 02/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation

class Directory {
    static let sharedInstance = Directory()

    private var storage = Dictionary<DirectoryItemType, DirectoryItem>()
    
    private init() {
        
    }
    
    func setItem(_ item : DirectoryItem) -> Directory {
        self.storage[item.getDirectoryType()] = item
        
        return self
    }
    
    func getAppSettings() -> AppSettings? {
        return self.storage[DirectoryItemType.appSettings] as! AppSettings?
    }
    
    func getParticipant() -> Participant? {
        return self.storage[DirectoryItemType.participant] as! Participant?
    }


    func getMap() -> FvMap? {
        return self.storage[DirectoryItemType.map] as! FvMap?
    }
    
    func getProgram() -> Program? {
        return self.storage[DirectoryItemType.program] as! Program?
    }
    
    func getFileLocationProvider() -> FileLocationProvider? {
        return self.storage[DirectoryItemType.fileLocationProvider] as! FileLocationProvider?
    }
    
    func getBarcode() -> Barcode? {
        return self.storage[DirectoryItemType.barcode] as! Barcode?

    }
}
