//
//  ProgramEvent.swift
//  Fastaval App
//
//  Created by Peter Lind on 13/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import UIKit
import RealmSwift

class ProgramEvent : Object {
    dynamic var id = 0
    dynamic var titleEn : String? = nil
    dynamic var titleDa : String? = nil
    dynamic var descriptionEn : String? = nil
    dynamic var descriptionDa : String? = nil
    dynamic var author : String? = nil

    dynamic var type : String? = nil
    let eventTimeSlots =  List<ProgramEventTimeslot>()
    
    override static func primaryKey() -> String? {
        return "id"
    }

    func getEventIconId() -> String? {
        guard let t = type else {
            return nil
        }
        
        return EventType.toImageId(EventType.translate(t))
    }
    
}
