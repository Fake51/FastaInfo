//
//  ParticipantJsonParser.swift
//  Fastaval App
//
//  Created by Peter Lind on 16/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import SwiftyJSON

class ParticipantJsonParser {
    func parse(_ json : JSON) -> ParticipantData {
        let id = Int(json["id"].string!)!
        let barcodeId = Int(json["barcode"].string!)!
        let checkedIn = json["checked_in"].number! != 0
        let hasSleepArea = json["sleep"]["id"].int! != 1
        let hasOrderedMattress = json["sleep"]["mattress"].int! == 1
        
        let storage = ParticipantData(value: [
            "id": id,
            "name": json["name"].string!,
            "barcodeId": barcodeId,
            "category": json["category"].string!,
            "checkedIn": checkedIn,
            "hasSleepArea": hasSleepArea,
            "hasOrderedMattress": hasOrderedMattress,
            "sleepAreaName": json["sleep"]["area_name"].string ?? "",
            "sleepAreaRoomId": json["sleep"]["area_id"].string ?? "",
            "messages": json["messages"].string ?? ""
            ])
        
        if json["food"] != JSON.null {
            addFoodEvents(storage, json["food"])
        }
        
        if json["scheduling"] != JSON.null {
            addActivityEvents(storage, json["scheduling"])
        }

        return storage
    }
    
    private func addFoodEvents(_ participant : ParticipantData, _ input : JSON) {
        for (_, foodObject):(String, JSON) in input {
            let event = ParticipantEvent()

            event.type = EventType.translate(EventType.food)
            event.start = Date(timeIntervalSince1970: TimeInterval(foodObject["time"].number!))
            event.end = Date(timeIntervalSince1970: TimeInterval(foodObject["time_end"].number!  ))
            event.titleDa = foodObject["title_da"].string! + ": " + foodObject["text_da"].string!
            event.titleEn = foodObject["title_en"].string! + ": " + foodObject["text_en"].string!
            event.scheduleId = Int(foodObject["time_id"].string!)!

            participant.events.append(event)
        }
    }
    
    private func addActivityEvents(_ participant : ParticipantData, _ input : JSON) {
        for (_, scheduleObject):(String, JSON) in input {
            let event = ParticipantEvent()

            event.type = EventType.translate(EventType.translate(scheduleObject["activity_type"].string!))
            event.start = Date(timeIntervalSince1970: TimeInterval(scheduleObject["start"].number!))
            event.end = Date(timeIntervalSince1970: TimeInterval(scheduleObject["stop"].number!))
            event.titleDa = scheduleObject["title_da"].string ?? ""
            event.titleEn = scheduleObject["title_en"].string ?? ""
            event.scheduleId = Int(scheduleObject["schedule_id"].string!)!
           
            event.meetingRoomId = scheduleObject["meet_room_id"].string ?? ""

            event.meetingRoomTitleEn = scheduleObject["meet_room_name"].string ?? ""
            event.meetingRoomTitleDa = scheduleObject["meet_room_name"].string ?? ""
            
            event.activityRoomId = scheduleObject["play_room_id"].string ?? ""
            
            event.activityRoomTitleEn = scheduleObject["play_room_name"].string ?? ""
            event.activityRoomTitleDa = scheduleObject["play_room_name"].string ?? ""
            event.eventId = Int(scheduleObject["id"].string ?? "0") ?? 0

            participant.events.append(event)
        }
        
    }

}
