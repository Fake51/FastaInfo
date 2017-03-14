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
    
    private var foregroundAlerts = [FvForegroundAlert]()
    
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
            
            self.handleNotifications()
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
            .subscribe(self, messageKey: AppMessages.SettingsType)
        
        updateState()
        broadcastState()
        
        handleNotifications()
    }

    private func handleNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
        
        for alert in foregroundAlerts {
            alert.remove()
        }
        
        foregroundAlerts = [FvForegroundAlert]()

        if self.state == ParticipantState.loggedInCheckedIn {

            if self.settings.getUseNotifications() {
                for event in self.program {
                    // todo set notification date properly: start minus 15 minutes
                    // set double notifications, if event is before 9.30
                    let alarmTime = event.start.addingTimeInterval(-15*60)

                    if alarmTime.compare(Date()) == ComparisonResult.orderedDescending {
                        scheduleNormalAlarm(event, alarmTime)

                        if event.isMorningEvent() {
                            let eveningAlarmTime = makeEveningAlarmTime(event)
                            
                            if eveningAlarmTime.compare(Date()) == ComparisonResult.orderedDescending {
                                scheduleEveningAlarm(event, eveningAlarmTime)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    func makeEveningAlarmTime(_ event : ParticipantEvent) -> Date {
        let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: event.start)!
        var components = Calendar.current.dateComponents([.year, .month, .day], from: dayBefore)
        
        components.hour = 21
        components.minute = 0

        return Calendar.current.date(from: components)!
    }
    
    func scheduleEveningAlarm(_ event : ParticipantEvent, _ alarmTime : Date) {
        let language = self.settings.getLanguage()
        
        var eventTitle : String
        
        if language == AppLanguage.english {
            eventTitle = event.titleEn
            
        } else {
            eventTitle = event.titleDa
        }
        
        let reminderText = "Heads up! You have ".localized(lang: language.toString()) + eventTitle + " in the morning.".localized(lang: language.toString());
        
        scheduleAlarm(reminderText, alarmTime)
        
        let header = "Fastaval Reminder".localized(lang: language.toString())
        
        foregroundAlerts.append(FvForegroundAlert(alertTime: alarmTime, alertText: "\(header):\n\(reminderText)"))

    }

    
    func scheduleNormalAlarm(_ event : ParticipantEvent, _ alarmTime : Date) {
        let language = self.settings.getLanguage()
        
        var eventTitle : String
        
        if language == AppLanguage.english {
            eventTitle = event.titleEn
            
        } else {
            eventTitle = event.titleDa
        }

        let reminderText = eventTitle + " starts in 15 minutes".localized(lang: language.toString())
        
        scheduleAlarm(reminderText, alarmTime)

        let header = "Fastaval Reminder".localized(lang: language.toString())

        foregroundAlerts.append(FvForegroundAlert(alertTime: alarmTime, alertText: "\(header):\n\(reminderText)"))
    }

    private func scheduleAlarm(_ text : String, _ time : Date) {
        let notification = UILocalNotification()
        notification.timeZone = TimeZone(identifier: "Europe/Copenhagen")
        notification.fireDate = time
        
        let language = self.settings.getLanguage()

        notification.alertBody = text
        notification.alertTitle = "Fastaval Reminder".localized(lang: language.toString())
        
        UIApplication.shared.scheduleLocalNotification(notification)

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
        switch message {
        case AppMessages.remoteSync:
            guard let data = getFromLocalStore() else {
                return
            }
            
            if self.state == ParticipantState.loggedInCheckedIn || self.state == ParticipantState.loggedInNotCheckedIn {
                self.fetchUserData(data.id, data.password)
                
            }
            
        case AppMessages.settings:
            handleNotifications()
            break
        default:
            break
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
        
        handleNotifications()
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
