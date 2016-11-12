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
    
    let events = List<ProgramEvent>()

    override static func primaryKey() -> String? {
        return "timeId"
    }
    
    func getSortedEvents(_ language : AppLanguage) -> Results<ProgramEvent> {
        var field : String
        
        switch language {
        case AppLanguage.english:
            field = "titleEn"
        case AppLanguage.danish:
            field = "titleDa"
        }
        
        return events.sorted(byProperty: field)
    }

    func getSortedPublicEvents(_ language : AppLanguage) -> Results<ProgramEvent> {
        return getSortedEvents(language).filter("type != 'system'")
    }
    
    func hasNonSystemEvents() -> Bool {
        return events.filter("type != 'system'").count > 0
    }
}
