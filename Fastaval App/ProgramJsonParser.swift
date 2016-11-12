//
//  ProgramJsonParser.swift
//  Fastaval App
//
//  Created by Peter Lind on 12/10/16.
//  Copyright © 2016 Fastaval. All rights reserved.
//

import SwiftyJSON
import UIKit

class ProgramJsonParser {
    fileprivate var dates = Dictionary<Date, ProgramDate>()
    
    fileprivate var timeslots = Dictionary<Date, ProgramTimeslot>()
    
    fileprivate var events = Dictionary<Int, ProgramEvent>()
    
    fileprivate let dayFormatter : DateFormatter
    
    private let timeslotFormatter : DateFormatter

    private var dateTimeslots = Dictionary<ProgramDate, Dictionary<Date, ProgramTimeslot>>()
    
    fileprivate func getDate(_ time : Date) -> ProgramDate {
        let dateId = dayFormatter.string(from: time.addingTimeInterval(TimeInterval(-60*60*4)))
        let date = dayFormatter.date(from: dateId)!
        
        if dates[date] == nil {
            dates[date] = ProgramDate(value: ["date": date, "dateId": dateId])
        }
        
        return dates[date]!
    }

    fileprivate func getSlot(_ time : Date, _ date : ProgramDate) -> ProgramTimeslot {
        if timeslots[time] == nil {
            timeslots[time] = ProgramTimeslot(value: ["time": time, "programDate": date, "timeId": timeslotFormatter.string(from: time)])
        }

        return timeslots[time]!
    }

    fileprivate func getEvent(_ activity : JSON, _ slot : ProgramTimeslot) -> ProgramEvent? {
        guard let eventId = activity["aktivitet_id"].int else {
            return nil
        }
        
        if events[eventId] == nil {
            events[eventId] = ProgramEvent(value: ["id": eventId, "type": activity["type"].string!, "titleEn": activity["title_en"].string!, "titleDa": activity["title_da"].string!, "descriptionEn": activity["text_en"].string!, "descriptionDa": activity["text_da"].string!, "author": activity["author"].string!])
        }
        
        return events[eventId]
    }
    
    init() {
        dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        
        timeslotFormatter = DateFormatter()
        timeslotFormatter.dateFormat = "yyyy-MM-dd hh:mm"

    }
    
    func makeActivityData(json: JSON) -> Dictionary<Date, ProgramDate> {
        for (_, activity):(String, JSON) in json {
            for (key, activityProp):(String, JSON) in activity {
                if key == "afviklinger" {
                    for (_, schedule):(String, JSON) in activityProp {
                        let timestamp: NSNumber? = schedule["start"].number
                        let timeslot = Date(timeIntervalSince1970: TimeInterval(timestamp!))
                        
                        let date = getDate(timeslot)
                        let slot = getSlot(timeslot, date)

                        if let event = getEvent(activity, slot) {
                            if dateTimeslots[date] == nil {
                                dateTimeslots[date] = Dictionary<Date, ProgramTimeslot>()
                            }

                            dateTimeslots[date]![slot.time] = slot

                            slot.programDate = date
                            slot.events.append(event)
                            
                            event.timeSlots.append(slot)
                        }
                    }
                }
            }
        }

        for (programDate, timeslots) in dateTimeslots {
            for (_, programTimeslot) in timeslots {
                programDate.timeslots.append(programTimeslot)
            }
        }
        
        return dates

    }

}
