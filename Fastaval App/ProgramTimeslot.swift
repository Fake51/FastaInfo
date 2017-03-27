//
//  ProgramTimeslot.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramTimeslot : Object{
    dynamic var time = Date()
    
    dynamic var timeId : String?

    dynamic var programDate : ProgramDate?
    
    let eventTimeslots = List<ProgramEventTimeslot>()

    var sortedCache : [AppLanguage : [ProgramEventTimeslot]] = [:]
    
    override static func primaryKey() -> String? {
        return "timeId"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["tmpID"]
    }
    
    func getSortedEvents(_ language : AppLanguage) -> [ProgramEventTimeslot] {
        var field : String

        switch language {
        case AppLanguage.english:
            field = "titleEn"
        case AppLanguage.danish:
            field = "titleDa"
        }
        
        let slots = eventTimeslots.filter("event != nil").map {(timeslot) -> ProgramEventTimeslot in
            return timeslot
        }
        
        let newEvents = slots.filter {(slot) -> Bool in
            return slot.event?[field] != nil && slot.event?[field] as! String != ""
        }
        
        return newEvents.sorted {
            (slot1, slot2) -> Bool in
            switch language {
            case AppLanguage.english:
                return (slot1.event!.titleEn ?? "") < (slot2.event!.titleEn ?? "")
            case AppLanguage.danish:
                return (slot1.event!.titleDa ?? "") < (slot2.event!.titleDa ?? "")
            }
        }
    }

    func getSortedPublicEvents(_ language : AppLanguage) -> [ProgramEventTimeslot] {

        if sortedCache[language] != nil {
            return sortedCache[language]!
        }
        
        sortedCache[language] = getSortedEvents(language).filter {(slot) -> Bool in
            return slot.event!.type != "system"
        }
        
        return sortedCache[language]!
    }
    
    func hasNonSystemEvents(_ language : AppLanguage) -> Bool {
        return getSortedPublicEvents(language).count > 0
    }
}
