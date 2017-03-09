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

    private var uuid = UUID().uuidString
    
    public var name : String {
        get {
            guard let data = getFromLocalStore() else {
                return ""
            }
            
            return data.name!
        }
    }
    
    public var id : Int {
        get {
            guard let data = getFromLocalStore() else {
                return 0
            }
            
            return data.id
        }
    }
    
    public var messages : String {
        get {
            guard let data = getFromLocalStore() else {
                return ""
            }
            
            return data.messages
        }
    }
    
    public var program : [ParticipantEvent] {
        get {
            var output = [ParticipantEvent]()
            
            guard let data = getFromLocalStore() else {
                return output
            }

            for event in data.events.sorted(byKeyPath: "start") {
                output.append(event)
            }
            
            return output
        }
    }
    
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
                let data = ParticipantData(value: ["password": password, "id": id])

                self.updateLocalStorage(data)
                
                return
            }

            let parsed = ParticipantJsonParser().parse(json)
            
            parsed.password = password
            self.updateLocalStorage(parsed)
            self.updateState()
            self.broadcastState()
        }
        
    }
    
    private func updateLocalStorage(_ parsed : ParticipantData) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(parsed, update: true)
        }

    }
    
    func getState() -> ParticipantState {
        return state
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
        
        updateState()
        broadcastState()
    }

    func broadcastState() {
        Broadcaster.sharedInstance.publish(message: AppMessages.user)

    }
    
    private func updateState() {
        guard let data = getFromLocalStore() else {
            self.state = ParticipantState.notLoggedIn
            return
        }
        
        if data.barcodeId > 0 {
            if data.checkedIn {
                self.state = ParticipantState.loggedInCheckedIn
            } else {
                self.state = ParticipantState.loggedInNotCheckedIn
                
            }

        } else {
            if data.id != 0, data.password.characters.count > 0 {
                self.state = ParticipantState.failedLogin
                
            } else {
                self.state = ParticipantState.notLoggedIn
                
            }
        }

    }
    
    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.participant
    }

    
    func receive(_ message: Message) {
        guard let data = getFromLocalStore() else {
            return
        }

        if self.state == ParticipantState.loggedInCheckedIn || self.state == ParticipantState.loggedInNotCheckedIn {
            self.fetchUserData(data.id, data.password)
            
        }
    }
    
    private func purgeLocalData(_ data : ParticipantData) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(data)
        }
    }
    
    func attemptLogin(_ id : Int, _ password : String) {
        if let data = getFromLocalStore() {
            purgeLocalData(data)
        }

        fetchUserData(id, password)

    }
    
    func doLogout() {
        guard let data = getFromLocalStore() else {
            return
        }
        
        purgeLocalData(data)

        updateState()
        broadcastState()
    }
    
    func getSleepInfoTitle() -> String {
        guard let data = getFromLocalStore() else {
            return ""
        }
        
        let lang = settings.getLanguage().toString()
        
        if !data.hasSleepArea {
            return "Not sleeping at Fastaval".localized(lang: lang)
        }
        
        return data.sleepAreaName
    }
}
