//
//  Program.swift
//  Fastaval App
//
//  Created by Peter Lind on 11/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//


import UIKit
import SwiftyJSON
import RealmSwift

class Program : Stateful, RemoteDependency, DirectoryItem, Subscriber {
    
    private var state = ProgramState.notReady
    
    private let infosysApi : JsonApi
    
    private let settings : AppSettings

    private var uuid = UUID().uuidString

    func getSubscriberId() -> String {
        return uuid
    }
    
    private var currentEvent : ProgramEvent?
    
    init(infosysApi: JsonApi, settings: AppSettings) {
        self.infosysApi = infosysApi
        self.settings = settings
    }
    
    func setCurrentEvent(_ event : ProgramEvent) {
        currentEvent = event
    }
    
    func getCurrentEvent() -> ProgramEvent? {
        return currentEvent
    }
    
    func fetchProgramData() {
        
        infosysApi.getProgramData() { (jsonData : JSON?) in
            guard let json = jsonData else {
                return
            }
            
            let parser = ProgramJsonParser()
            let parsed = parser.makeActivityData(json: json)
            
            let realm = try! Realm()
            try! realm.write {
                for (_, programDate) in parsed {
                    realm.add(programDate, update: true)
                }
            }
            
            self.updateState()
        }
        
    }
    
    func getState() -> ProgramState {
        return state
    }

    func updateState() {
        let programData = getData()
                
        self.state = programData.count > 0 ? ProgramState.ready : ProgramState.notReady
        Broadcaster.sharedInstance.publish(message: AppMessages.program)
    }
    
    func initialize() {
        if getData().count == 0 {
            fetchProgramData()
            
        }

        let _ = Broadcaster.sharedInstance.subscribe(self, messageKey: AppMessages.RemoteSyncType)
        
        updateState()
    }
    
    func receive(_ message: Message) {
        self.fetchProgramData()
    }
    
    func getDirectoryType() -> DirectoryItemType {
        return DirectoryItemType.program
    }
    
    func getData() -> Results<ProgramDate> {
        let realm = try! Realm()
        
        return realm.objects(ProgramDate.self)
    }
}