//
//  FvMap.swift
//  Fastaval App
//
//  Created by Peter Lind on 03/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import Just

class FvMap : Stateful {

    fileprivate var state = FvMapState.notReady

    fileprivate let mapUrl = "https://infosys.fastaval.dk/img/location.svg"

    
    init() {
        let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        // create a name for your image
        let fileURL = documentsDirectoryURL.appendingPathComponent("location.svg")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            Just.get(mapUrl, params:[:]) { (r) in
                if r.ok {
                    try! r.content?.write(to: fileURL)
                    
                    Broadcaster.sharedInstance.publish(message: AppMessages.map)
                    self.state = FvMapState.ready
                }
                
            }
        } else {
            Broadcaster.sharedInstance.publish(message: AppMessages.map)
            state = FvMapState.ready
            
        }
        
    }
    
    func getState() -> FvMapState {
        return state
    }
}
