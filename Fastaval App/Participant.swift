//
//  Participant.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/09/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Participant : Stateful, RemoteDependency, DirectoryItem, Subscriber {
    
    private var state = ParticipantState.notReady

    private let infosysApi : JsonApi

    private let settings : AppSettings
    
    private var participantId : Int?
    
    private var password : String?
    
    private var barcodeId : Int?
    
    private var category : String?

    private var checkedIn = false
    
    private var name : String?
    
    private var uuid = UUID().uuidString
    
    func getSubscriberId() -> String {
        return uuid
    }

    init(infosysApi: JsonApi, settings: AppSettings) {
        self.infosysApi = infosysApi
        self.settings = settings
    }

    func fetchUserData(_ id : Int, _ password : String) {

        infosysApi.getParticipantData(userId: id, password: password) { (jsonData : JSON?) in
            guard let json = jsonData else {
                return
            }

            let parsed = ParticipantJsonParser().parse(json)
            
            parsed.password = password
            self.populateFromDataObject(parsed)
            self.updateState()
            self.updateLocalStorage(parsed)
        }
        
    }

    private func populateData(_ storage : ParticipantData, _ original : ParticipantData) -> ParticipantData {

        storage.id = original.id
        storage.password = original.password
        storage.name = original.name
        storage.checkedIn = original.checkedIn
        storage.category = original.category
        storage.barcodeId = original.barcodeId
        
        return storage
    }
    
    private func updateLocalStorage(_ parsed : ParticipantData) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(self.populateData(ParticipantData(), parsed), update: true)
        }

    }
    
    func getState() -> ParticipantState {
        return state
    }

    private func populateFromDataObject(_ data : ParticipantData) {

        self.participantId = data.id
        self.password = data.password
        self.checkedIn = data.checkedIn
        self.category = data.category
        self.barcodeId = data.barcodeId
        self.name = data.name
    }
    
    private func populateFromLocalStore() {
        if let data = getFromLocalStore() {
            populateFromDataObject(data)
        }
    }
    
    private func getFromLocalStore() -> ParticipantData? {
        let realm = try! Realm()
        
        let data = realm.objects(ParticipantData.self)

        if data.count > 0 {
            return data.first!
        }
        
        return nil
    }
    
    func initialize() {
        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.RemoteSyncType)

        populateFromLocalStore()
        
        updateState()
    }
    
    private func updateState() {
        if self.password != nil, self.password!.characters.count > 0 {
            
            if self.checkedIn {
                self.state = ParticipantState.loggedInCheckedIn
            } else {
                self.state = ParticipantState.loggedInNotCheckedIn
                
            }
            
        } else {
            if self.participantId != nil, self.password != nil {
                self.state = ParticipantState.failedLogin
                
            } else {
                self.state = ParticipantState.notLoggedIn
                
            }
        }

        Broadcaster.sharedInstance.publish(message: AppMessages.user)
    }
    
    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.participant
    }

    
    func receive(_ message: Message) {
        if let id = self.participantId, let password = self.password {
            self.fetchUserData(id, password)
            
        }
    }
    
    func attemptLogin(_ id : Int, _ password : String) {
        self.fetchUserData(id, password)

    }
    
    func doLogout() {
        if self.password == nil {
            return
        }
        
        self.password = nil
        
        guard let data = getFromLocalStore() else {
            return
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(data)
        }

        self.updateState()
    }
 
    func getName () -> String {
        return name ?? ""
    }
}
