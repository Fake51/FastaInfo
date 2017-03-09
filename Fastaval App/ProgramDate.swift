//
//  ProgramDate.swift
//  Fastaval App
//
//  Created by Peter Lind on 12/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramDate : Object {
    dynamic var date = Date()
    dynamic var dateId : String?
    
    let timeslots = List<ProgramTimeslot>()

    override static func primaryKey() -> String? {
        return "dateId"
    }
    
    func getHumanFriendlyDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMMM"
        
        var locale : Locale
        
        let language = Directory.sharedInstance.getAppSettings()?.getLanguage() ?? AppLanguage.english
        
        switch language {
        case .danish: locale = Locale(identifier: "da-DK")
        case .english: locale = Locale(identifier: "en-UK")
        }

        formatter.locale = locale
        
        return formatter.string(from: date)
    }
    
    func getPublicTimeslots() -> [ProgramTimeslot] {
        var output = [ProgramTimeslot]()

        for timeslot in timeslots {
            if timeslot.hasNonSystemEvents() {
                output.append(timeslot)
            }
            
        }
        
        return output
    }
    
    func getSortedTimeslots() -> Results<ProgramTimeslot> {
        return timeslots.sorted(byKeyPath: "time")
    }
    
    func getSortedPublicTimeslots() -> [ProgramTimeslot] {
        var output = [ProgramTimeslot]()
        
        for timeslot in getSortedTimeslots() {
            if timeslot.hasNonSystemEvents() {
                output.append(timeslot)
            }
        }
        
        return output
    }
}
