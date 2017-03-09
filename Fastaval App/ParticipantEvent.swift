//
//  ParticipantEvent.swift
//  Fastaval App
//
//  Created by Peter Lind on 23/11/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import Foundation
import RealmSwift

class ParticipantEvent : Object {
    dynamic var type = ""
    
    dynamic var start = Date()
    
    dynamic var end = Date()
    
    dynamic var titleEn = ""
    
    dynamic var titleDa = ""
    
    dynamic var eventId = 0
    
    dynamic var scheduleId = 0
    
    dynamic var meetingRoomTitleEn = ""
    
    dynamic var meetingRoomTitleDa = ""
    
    dynamic var meetingRoomId = ""

    dynamic var activityRoomTitleEn = ""
    
    dynamic var activityRoomTitleDa = ""
    
    dynamic var activityRoomId = ""

    override static func primaryKey() -> String? {
        return "scheduleId"
    }
}
