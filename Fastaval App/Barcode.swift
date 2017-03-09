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
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.UserType)
        
        // check participant state and update accordingly
    }

    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.barcode
    }
    
    func fetchBarcode(_ participant : Participant) {
        let locationProvider = FileLocationProvider()
        
        infosysApi.retrieveBarcode(userId: participant.id, location: locationProvider.getBarcodeLocation()) { () in
            self.state = BarcodeState.ready
            self.broadcastUpdate()
        }
    }
    
    private func broadcastUpdate() {
        Broadcaster.sharedInstance.publish(message: AppMessages.barcode)
    }
    
    private func unlinkBarcodeImage() {
        let locationProvider = FileLocationProvider()
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: locationProvider.getBarcodeLocation())
        } catch {
            // do nothing much
        }
    }
    
    func receive(_ message: Message) {
        switch message {
        case AppMessages.user:
            guard let participant = Directory.sharedInstance.getParticipant() else {
                return
            }
            
            if state == BarcodeState.ready && participant.getState() != ParticipantState.loggedInCheckedIn {
                state = BarcodeState.notReady
                Broadcaster.sharedInstance.publish(message: AppMessages.barcode)
                unlinkBarcodeImage()
                break
            }

            if state == BarcodeState.notReady && participant.getState() == ParticipantState.loggedInCheckedIn {
                fetchBarcode(participant)
            }

            break
            
        case AppMessages.remoteSync:
            guard let participant = Directory.sharedInstance.getParticipant() else {
                return
            }

            if participant.getState() == ParticipantState.loggedInCheckedIn {
                fetchBarcode(participant)
            }

            break
            
        default:
            break
        }
    }
}
